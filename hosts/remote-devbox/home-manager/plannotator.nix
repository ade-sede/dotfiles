# Plannotator overrides for remote-devbox — no stray "session ready" stderr text in opencode over SSH, fixed port for forwarding.
{...}: {
  home.sessionVariables = {
    PLANNOTATOR_REMOTE = "0";
    PLANNOTATOR_SKIP_BROWSER_OPEN = "1";
    PLANNOTATOR_PORT = "19432";
  };
}
