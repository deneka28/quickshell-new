pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string decodedId
    property string contentType: "text"
    property bool runningDecode: false
    property var copyItem
    property bool runningCopy
    property bool runningList: false
    property bool runningWipe: false
    property bool runningCount: false
    property int clipHistCount: 0
    property list<string> clipHistList: []
    property var _tempList: [] // Временное хранилище
    property var binaryPreviews: ({})
    property string _decodePreviewLine: ""
    property string _decodePreviewId: ""

    signal decoded(var data)
    signal copy

    function decodeBinaryPreview(fullLine, entryId) {
        if (root.binaryPreviews[entryId]) return
        _decodePreviewLine = fullLine
        _decodePreviewId = entryId
        previewDecodeProc.running = true
    }


    function refreshList() {
        root.clipHistList = [];
        root._tempList = [];
        runningList = true;
    }

    Process {
        id: previewDecodeProc
        running: false
        command: ["bash", "-c",
            `printf '%s' '${root._decodePreviewLine.replace(/'/g, "'\\''")}' | cliphist decode > /tmp/cliphist_preview_${root._decodePreviewId}.png`
        ]
        onExited: (code) => {
            if (code === 0) {
                let previews = Object.assign({}, root.binaryPreviews)
                previews[root._decodePreviewId] = `/tmp/cliphist_preview_${root._decodePreviewId}.png`
                root.binaryPreviews = previews
            }
            running = false
        }
    }

    Process {
        id: clipHist

        running: root.runningList
        command: ["cliphist", "list"]

        stdout: SplitParser {
            onRead: data => {
                console.log("CLIPHIST:", JSON.stringify(data));
                root._tempList.push(data);
            }
        }

        stderr: SplitParser {
            onRead: data => {
                console.log("CLIPHIST ERROR:", data);
            }
        }

        onExited: (code, status) => {
            console.log("CLIPHIST EXIT:", code, status);
            console.log("CLIPHIST ITEMS:", root._tempList.length);

            root.clipHistList = root._tempList;
            root._tempList = [];
            root.runningList = false;
        }
    }
    Process {
        id: clipHistWipe
        running: root.runningCount
        command: ["cliphist", "wipe"]
        onExited: {
            root.runningWipe = false;
            root.clipHistList = [];
            root.clipHistCount = 0;
        }
    }
    Process {
        id: clipHistCount
        running: root.runningCount
        command: ["sh", "-c", "cliphist list | wc -l"]
        stdout: SplitParser {
            onRead: data => {
                root.clipHistCount = data;
                if (Number(data) >= 500) {
                    root.runningWipe = true;
                }
            }
        }
        onExited: (code, status) => {
            root.runningCount = false;
        }
    }
    Process {
        id: clipHistDecode
        running: root.runningDecode
        command: ["sh", "-c", `echo -n '${root.decodedId}' | cliphist decode | tr -d '\r\n'`]
        // Добавили tr -d '\r\n' чтобы убрать переносы строк

        stdout: SplitParser {
            onRead: data => {
                root.decoded(data);
            }
        }
        onExited: root.runningDecode = false
    }
    Process {
        id: clipHistCopyImage
        running: false
        command: []

        stderr: SplitParser {
            onRead: data => {
                console.log("Image copy stderr:", data);
            }
        }

        onExited: (code, status) => {
            console.log("Image copy process exited with code:", code, "status:", status);
            root.runningCopy = false;
        }
    }
    Process {
        id: clipHistCopy
        running: root.runningCopy && root.contentType === "text"
        command: ["sh", "-c", `echo -n '${root.decodedId}' | cliphist decode | wl-copy`]

        stdout: SplitParser {
            onRead: data => {
                console.log("Copy stdout:", data);
            }
        }

        stderr: SplitParser {
            onRead: data => {
                console.log("Copy stderr:", data);
            }
        }

        onStarted: {
            console.log("Copy process started with ID:", root.decodedId);
        }
        onExited: (code, status) => {
            console.log("Copy process exited with code:", code, "status:", status);
            if (code === 0) {
                console.log("Successfuly copied to clipboard!");
            }
            root.runningCopy = false;
        }
    }

function copyEntry(fullLine, type) {
    contentType = type

    if (type === "image-file") {
        clipHistDecode.command = ["bash", "-c",
            `printf '%s' '${fullLine.replace(/'/g, "'\\''")}' | cliphist decode`
        ]
        runningDecode = true

    } else if (type === "binary") {
        clipHistCopyImage.command = ["bash", "-c",
            `printf '%s' '${fullLine.replace(/'/g, "'\\''")}' | cliphist decode | wl-copy`
        ]
        clipHistCopyImage.running = true

    } else {
        // Для текста тоже используем полную строку
        clipHistCopy.command = ["bash", "-c",
            `printf '%s' '${fullLine.replace(/'/g, "'\\''")}' | cliphist decode | wl-copy`
        ]
        clipHistCopy.running = true
    }
}

    Connections {
        target: root
        enabled: root.contentType === "image-file"
        function onDecoded(data) {
            // Убираем ВСЕ непечатаемые символы
            let cleanData = data.replace(/[\r\n\t]/g, '').trim();
            let path = cleanData.replace("file://", "");
            let decodedPath = decodeURIComponent(path);

            console.log("Decoded path:", decodedPath);

            // Определяем MIME-тип по расширению
            let mimeType = "image/png";
            if (decodedPath.endsWith(".jpg") || decodedPath.endsWith(".jpeg")) {
                mimeType = "image/jpeg";
            } else if (decodedPath.endsWith(".png")) {
                mimeType = "image/png";
            } else if (decodedPath.endsWith(".gif")) {
                mimeType = "image/gif";
            } else if (decodedPath.endsWith(".webp")) {
                mimeType = "image/webp";
            } else if (decodedPath.endsWith(".svg")) {
                mimeType = "image/svg+xml";
            }

            console.log("MIME type:", mimeType);

            // Копируем И как изображение И как URI файла
            // Это позволит вставлять в разные приложения
            clipHistCopyImage.command = ["bash", "-c", `printf 'file://%s' "${decodedPath}" | wl-copy --type text/uri-list`];
            clipHistCopyImage.running = true;
        }
    }

    Process {
        id: clipHistDelete
        running: false
        command: []

        stderr: SplitParser {
            onRead: data => {
                console.log("Delete stderr:", data);
            }
        }

        onExited: (code, status) => {
            if (code === 0) {
                root._tempList = [];
                // Обновляем список после удаления
                console.log("Delete process exited with code:", code);
                //root.refreshList()
                root.runningList = true;
            }
        }
    }
    function deleteEntry(fullLine) {
        if (!fullLine)
            return;
        console.log("Deleting entry:", fullLine);
        clipHistDelete.command = ["sh", "-c", `echo "${fullLine.replace(/"/g, '\\"')}" | cliphist delete`];
        clipHistDelete.running = true;
    }
}
