export function copyTextToClipboard(v: string): boolean {
  const input = document.createElement("input");
  input.style.height = "0px";
  input.style.opacity = "0";
  input.style.position = "absolute";
  input.style.zIndex = "-1";
  input.value = v;
  document.body.appendChild(input);
  input.select();
  input.setSelectionRange(0, v.length);
  const success = document.execCommand("copy");
  document.body.removeChild(input);
  return success;
}
