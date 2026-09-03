pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<var> devices: []
    property bool runningList: false
    property bool runningMount: false
    property bool runningUmount: false
    property string mountTarget: ""
    property string umountTarget: ""
    property string listBuffer: ""

    // Хранем имя устройства для уведомления
    property string lastMountDevice: ""
    property string lastUmountDevice: ""

    signal mounted(string device)
    signal unmounted(string device)
    signal mountError(string error)

    function refresh() {
        // devices = [];
        listBuffer = "";
        runningList = true;
    }

    function mount(device) {
        lastMountDevice = device;
        mountTarget = device;
        runningMount = true;
    }

    function umount(device) {
        lastUmountDevice = device;
        umountTarget = device;
        runningUmount = true;
    }

    // Получаем читаемое имя устройства из списка
    function getDeviceName(device) {
        for (let i = 0; i < devices.length; i++) {
            if (devices[i].device === device) {
                return devices[i].label !== "" ? devices[i].label : devices[i].name;
            }
        }
        return device;
    }

    Process {
        id: listProcess
        running: root.runningList
        command: ["lsblk", "-o", "NAME,FSTYPE,LABEL,MOUNTPOINT,SIZE,TYPE", "-I", "8", "-J", "-b"]

        stdout: SplitParser {
            onRead: data => {
                root.listBuffer += data;
            }
        }

        onExited: (code, status) => {
            root.runningList = false;

            if (code === 0 && root.listBuffer !== "") {
                try {
                    let parsed = JSON.parse(root.listBuffer);
                    let devs = [];

                    parsed.blockdevices.forEach(disk => {
                        if (disk.children) {
                            disk.children.forEach(part => {
                                devs.push({
                                    name: part.name,
                                    fstype: part.fstype || "",
                                    label: part.label || "",
                                    mountpoint: part.mountpoint || "",
                                    size: part.size,
                                    type: part.type,
                                    device: "/dev/" + part.name,
                                    isMounted: part.mountpoint !== null && part.mountpoint !== ""
                                });
                            });
                        } else {
                            devs.push({
                                name: disk.name,
                                fstype: disk.fstype || "",
                                label: disk.label || "",
                                mountpoint: disk.mountpoint || "",
                                size: disk.size,
                                type: disk.type,
                                device: "/dev/" + disk.name,
                                isMounted: disk.mountpoint !== null && disk.mountpoint !== ""
                            });
                        }
                    });

                    root.devices = devs;
                } catch (e) {
                    console.log("Parse error:", e);
                    console.log("Buffer content:", root.listBuffer);
                }
            }

            root.listBuffer = "";
        }
    }

    Process {
        id: mountProcess
        running: root.runningMount
        command: ["sh", "-c", `udisksctl mount -b ${root.mountTarget}`]

        stderr: SplitParser {
            onRead: data => {
                console.log("Mount stderr:", data);
                root.mountError(data);
            }
        }

        stdout: SplitParser {
            onRead: data => {
                console.log("Mount stdout:", data);
                root.mounted(root.mountTarget);
            }
        }

        onExited: (code, status) => {
            root.runningMount = false;
            root.refresh();
        }
    }

    Process {
        id: umountProcess
        running: root.runningUmount
        command: ["sh", "-c", `udisksctl unmount -b ${root.umountTarget}`]

        stderr: SplitParser {
            onRead: data => {
                console.log("Umount stderr:", data);
                root.mountError(data);
            }
        }

        stdout: SplitParser {
            onRead: data => {
                console.log("Umount stdout:", data);
                root.unmounted(root.umountTarget);
            }
        }

        onExited: (code, status) => {
            root.runningUmount = false;
            root.refresh();
        }
    }

    Timer {
        running: true
        interval: 5000
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()
}
