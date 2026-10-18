import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const STYLE_PATH = "~/.config/docs/writing-style.md";

const PROSE_EXTENSIONS = [".md", ".txt", ".py", ".ts", ".tsx"];

const PR_COMMANDS = [
  "gh pr create",
  "gh pr edit",
  "gis branch submit",
  "gs branch submit",
  "gis b s",
  "gs b s",
];

function shouldNudge(event: { toolName: string; input: Record<string, unknown> }) {
  if (event.toolName === "write" || event.toolName === "edit") {
    const filePath = String(event.input.filePath ?? "");
    return PROSE_EXTENSIONS.some((ext) => filePath.endsWith(ext));
  }
  if (event.toolName === "bash") {
    const command = String(event.input.command ?? "");
    return PR_COMMANDS.some((cmd) => command.includes(cmd));
  }
  return false;
}

export default function (pi: ExtensionAPI) {
  pi.on("tool_result", async (event) => {
    if (event.isError || !shouldNudge(event)) return;
    return {
      content: [...event.content, { type: "text", text: `[writing-style] Check against ${STYLE_PATH}` }],
    };
  });
}
