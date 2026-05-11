import * as React from "react"

interface ThemeToggleProps {
  theme: "light" | "dark"
  toggleTheme: () => void
}

const ThemeToggle: React.FC<ThemeToggleProps> = ({ theme, toggleTheme }) => {
  return (
    <button type="button" onClick={toggleTheme} className="theme-toggle-button">
      {theme === "dark" ? "Switch to light mode" : "Switch to dark mode"}
    </button>
  )
}

export default ThemeToggle
