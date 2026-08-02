pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    // Ждём готовности Pipewire
    property bool ready: Pipewire.ready

    property var sink: ready ? Pipewire.defaultAudioSink : null
    property var source: ready ? Pipewire.defaultAudioSource : null

    property real volume: sink?.audio?.volume ?? 0
    property bool muted: sink?.audio?.muted ?? false
    property string sinkName: sink?.description ?? ""

    property real micVolume: source?.audio?.volume ?? 0
    property bool micMuted: source?.audio?.muted ?? false
    property string sourceName: source?.description ?? ""

    // Биндим ноду через PwObjectTracker
    PwObjectTracker {
        objects: [root.sink, root.source].filter(n => n !== null)
    }

    function changeVolume(delta) {
        if (!ready || !sink?.audio)
            return;
        sink.audio.volume = Math.max(0, Math.min(1, sink.audio.volume + delta));
        // OsdService.showVolume(Math.round(sink.audio.volume * 100))
    }

    function setVolume(v) {
        if (!ready || !sink?.audio)
            return;
        sink.audio.volume = Math.max(0, Math.min(1, v));
        // OsdService.showVolume(Math.round(sink.audio.volume * 100))
    }

    function toggleMute() {
        if (!ready || !sink?.audio)
            return;
        sink.audio.muted = !sink.audio.muted;
        // OsdService.showVolume(Math.round(volume * 100))
    }

    function setMicVolume(v) {
        if (!ready || !source?.audio)
            return;
        source.audio.volume = Math.max(0, Math.min(1, v));
    }

    function toggleMicMute() {
        if (!ready || !source?.audio)
            return;
        source.audio.muted = !source.audio.muted;
    }

    property var sinks: {
        if (!ready)
            return [];
        const result = [];
        for (const node of Pipewire.nodes.values) {
            if (node.isSink && node.audio !== null && !node.isStream)
                result.push(node);
        }
        return result;
    }

    property var sources: {
        if (!ready)
            return [];
        const result = [];
        for (const node of Pipewire.nodes.values) {
            if (!node.isSink && node.audio !== null && !node.isStream)
                result.push(node);
        }
        return result;
    }

    function setSink(node) {
        Pipewire.preferredDefaultAudioSink = node;
    }

    function setSource(node) {
        Pipewire.preferredDefaultAudioSource = node;
    }
}
