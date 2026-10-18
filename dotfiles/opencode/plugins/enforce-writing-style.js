const STYLE_PATH = `${process.env.HOME}/.config/docs/writing-style.md`;

const PROSE_EXTENSIONS = [".md", ".txt", ".py", ".ts", ".tsx"];

const PR_COMMANDS = [
  "gh pr create",
  "gh pr edit",
  "gis branch submit",
  "gs branch submit",
  "gis b s",
  "gs b s",
];

function shouldNudge(tool, args) {
  if (tool === "write" || tool === "edit") {
    const filePath = args?.filePath ?? "";
    return PROSE_EXTENSIONS.some((ext) => filePath.endsWith(ext));
  }
  if (tool === "bash") {
    const command = args?.command ?? "";
    return PR_COMMANDS.some((cmd) => command.includes(cmd));
  }
  return false;
}

export const EnforceWritingStylePlugin = async ({ client }) => ({
  "tool.execute.after": async (input) => {
    const tool = input?.tool ?? "";
    const args = input?.args ?? {};
    if (!shouldNudge(tool, args)) return;

    try {
      await client.app.log({
        body: {
          service: "enforce-writing-style",
          level: "warn",
          message: "Prose written or edited. Check against writing style.",
          extra: { style: STYLE_PATH },
        },
      });
    } catch {}
  },
});
