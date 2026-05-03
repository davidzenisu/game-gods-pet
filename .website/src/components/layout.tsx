import * as React from "react"
import { Link } from "gatsby"
import ThemeToggle from "./theme-toggle"

interface LayoutProps {
  children: React.ReactNode
}

const pageStyles = {
  minHeight: "100vh",
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
  padding: "48px 24px",
}
const containerStyles = {
  width: "100%",
  maxWidth: 980,
  margin: "0 auto",
  padding: "44px 34px",
  borderRadius: 28,
  backgroundColor: "var(--surface)",
  boxShadow: "var(--shadow)",
  color: "var(--text)",
  textAlign: "center" as const,
}
const topBarStyles = {
  display: "flex",
  justifyContent: "space-between",
  alignItems: "center",
  gap: 20,
  marginBottom: 32,
  flexWrap: "wrap" as const,
}
const navLinkStyles = {
  color: "var(--accent)",
  textDecoration: "none",
  fontWeight: 700,
}
const navListStyles = {
  display: "flex",
  gap: 20,
  alignItems: "center",
  justifyContent: "center",
  flexWrap: "wrap" as const,
  margin: 0,
  padding: 0,
  listStyle: "none",
}

const Layout: React.FC<LayoutProps> = ({ children }) => {
  const [theme, setTheme] = React.useState<"light" | "dark">("light")

  React.useEffect(() => {
    const storedTheme = typeof window !== "undefined" ? window.localStorage.getItem("theme") : null
    const prefersDark = typeof window !== "undefined" && window.matchMedia("(prefers-color-scheme: dark)").matches
    const nextTheme = storedTheme === "light" || storedTheme === "dark" ? storedTheme : prefersDark ? "dark" : "light"
    setTheme(nextTheme)
    document.body.classList.remove("light-theme", "dark-theme")
    document.body.classList.add(`${nextTheme}-theme`)
  }, [])

  React.useEffect(() => {
    if (typeof window === "undefined") {
      return
    }
    window.localStorage.setItem("theme", theme)
    document.body.classList.remove("light-theme", "dark-theme")
    document.body.classList.add(`${theme}-theme`)
  }, [theme])

  const toggleTheme = () => setTheme(prev => (prev === "dark" ? "light" : "dark"))

  return (
    <main style={pageStyles}>
      <div style={containerStyles}>
        <div style={topBarStyles}>
          <ul style={navListStyles}>
            <li>
              <Link style={navLinkStyles} to="/">
                Home
              </Link>
            </li>
            <li>
              <Link style={navLinkStyles} to="/download">
                Download
              </Link>
            </li>
            <li>
              <Link style={navLinkStyles} to="/privacy-policy">
                Privacy Policy
              </Link>
            </li>
          </ul>
          <ThemeToggle theme={theme} toggleTheme={toggleTheme} />
        </div>
        {children}
      </div>
    </main>
  )
}

export default Layout
