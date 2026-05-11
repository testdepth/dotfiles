import { mkdir, readFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const CLIP_DIR = join(tmpdir(), "pi-clipboard-images");

async function hasPngpaste(pi: ExtensionAPI): Promise<boolean> {
	const result = await pi.exec("bash", ["-lc", "command -v pngpaste >/dev/null 2>&1"], {
		timeout: 5_000,
	});
	return result.code === 0;
}

async function writeClipboardPngWithOsascript(pi: ExtensionAPI, outputPath: string): Promise<boolean> {
	const escapedPath = outputPath.replace(/\\/g, "\\\\").replace(/"/g, '\\"');
	const script = [
		`set outPath to POSIX file \"${escapedPath}\"`,
		"try",
		"\tset pngData to the clipboard as «class PNGf»",
		"\tset fileRef to open for access outPath with write permission",
		"\tset eof of fileRef to 0",
		"\twrite pngData to fileRef",
		"\tclose access fileRef",
		"\treturn \"ok\"",
		"on error errMsg number errNum",
		"\ttry",
		"\t\tclose access outPath",
		"\tend try",
		"\terror errMsg number errNum",
		"end try",
	];

	const args = script.flatMap((line) => ["-e", line]);
	const result = await pi.exec("osascript", args, { timeout: 10_000 });
	return result.code === 0;
}

async function readClipboardImageBase64(pi: ExtensionAPI): Promise<string | null> {
	await mkdir(CLIP_DIR, { recursive: true });
	const outputPath = join(CLIP_DIR, `clipboard-${Date.now()}.png`);

	if (await hasPngpaste(pi)) {
		const result = await pi.exec("pngpaste", [outputPath], { timeout: 10_000 });
		if (result.code === 0) {
			const buf = await readFile(outputPath);
			if (buf.length > 0) return buf.toString("base64");
		}
	}

	const wrote = await writeClipboardPngWithOsascript(pi, outputPath);
	if (!wrote) return null;

	const buf = await readFile(outputPath);
	if (buf.length === 0) return null;
	return buf.toString("base64");
}

export default function (pi: ExtensionAPI) {
	const pasteClipboardImage = async (
		ctx: {
			ui: { notify: (message: string, level: "info" | "warning" | "error") => void; getEditorText: () => string; setEditorText: (text: string) => void };
			isIdle: () => boolean;
		},
		args: string,
	) => {
		if (process.platform !== "darwin") {
			ctx.ui.notify("/paste-image currently supports macOS clipboard only.", "warning");
			return;
		}

		const imageBase64 = await readClipboardImageBase64(pi);
		if (!imageBase64) {
			ctx.ui.notify("No image found in clipboard. Copy a screenshot first.", "warning");
			ctx.ui.notify("Tip: install pngpaste for better clipboard compatibility.", "info");
			return;
		}

		const editorText = ctx.ui.getEditorText().trim();
		const inputText = args.trim() || editorText;
		const content: Array<
			| { type: "text"; text: string }
			| { type: "image"; source: { type: "base64"; media_type: "image/png"; data: string } }
		> = [];

		if (inputText) {
			content.push({ type: "text", text: inputText });
		}

		content.push({
			type: "image",
			source: {
				type: "base64",
				media_type: "image/png",
				data: imageBase64,
			},
		});

		if (!ctx.isIdle()) {
			pi.sendUserMessage(content, { deliverAs: "followUp" });
			ctx.ui.notify("Clipboard image queued as follow-up message.", "info");
			return;
		}

		pi.sendUserMessage(content);
		if (editorText && !args.trim()) {
			ctx.ui.setEditorText("");
		}
	};

	pi.registerCommand("paste-image", {
		description: "Paste clipboard image into pi as a user image message",
		handler: async (args, ctx) => {
			await pasteClipboardImage(ctx, args);
		},
	});

}
