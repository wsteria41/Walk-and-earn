import { createContext, useContext, useState } from "react";

export const ThemeContext = createContext();

export const DARK = {
  mode: "dark",
  // Layout backgrounds
  bg:        "#080812",
  bgContent: "#0a0a14",
  bgSidebar: "linear-gradient(180deg,#11111d 0%,#0d0d18 100%)",
  bgTopbar:  "#0d0d18",
  bgBotbar:  "#0d0d18",
  bgCard:    "#13131f",
  bgInput:   "#16162a",
  bgUserBox: "#16162a",
  // Borders
  border:    "#1e1e30",
  borderSub: "#1a1a2c",
  // Text
  text:      "#f0ecff",
  textSub:   "#5a5a7a",
  textMuted: "#2e2e4a",
  textNav:   "#4a4a6a",
  textNavActive: "#ddd4ff",
  textUser:  "#c8c0e8",
  textEmail: "#3a3a5a",
  // Section label
  sectionLabel: "#2a2a42",
  // Chart
  chartGrid: "#1e1e30",
  chartTick: "#3a3a5a",
  chartTooltipBg: "#1a1a2e",
  chartTooltipBorder: "#2a2a4e",
  chartTooltipText: "#e0d7ff",
  chartCursor: "#ffffff06",
  // Stat card warn-off
  warnOffBg: "#ffffff06",
  warnOffBorder: "#1e1e2e",
};

export const LIGHT = {
  mode: "light",
  bg:        "#f4f4fb",
  bgContent: "#eeeef8",
  bgSidebar: "linear-gradient(180deg,#ffffff 0%,#f8f8ff 100%)",
  bgTopbar:  "#ffffff",
  bgBotbar:  "#ffffff",
  bgCard:    "#ffffff",
  bgInput:   "#f0f0fa",
  bgUserBox: "#f0f0fa",
  border:    "#e2e2f0",
  borderSub: "#e8e8f4",
  text:      "#1a1a2e",
  textSub:   "#7070a0",
  textMuted: "#b0b0cc",
  textNav:   "#9090b0",
  textNavActive: "#3d1fa8",
  textUser:  "#2a2a4a",
  textEmail: "#9090b0",
  sectionLabel: "#c0c0d8",
  chartGrid: "#e8e8f4",
  chartTick: "#a0a0c0",
  chartTooltipBg: "#ffffff",
  chartTooltipBorder: "#e0e0f0",
  chartTooltipText: "#1a1a2e",
  chartCursor: "#7c3aed08",
  warnOffBg: "#f8f8ff",
  warnOffBorder: "#e8e8f4",
};

export function ThemeProvider({ children }) {
  const [theme, setTheme] = useState(DARK);
  const toggle = () => setTheme(t => t.mode === "dark" ? LIGHT : DARK);
  return (
    <ThemeContext.Provider value={{ theme, toggle }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  return useContext(ThemeContext);
}