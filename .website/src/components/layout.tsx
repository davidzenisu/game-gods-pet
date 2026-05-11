import * as React from "react"
import { Link } from "gatsby"
import ThemeToggle from "./theme-toggle"

interface LayoutProps {
  children: React.ReactNode
}

const pageStyles = {
  minHeight: "100vh",
  display: "flex",
  alignItems: "flex-start",
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
            <li>
              <a
                style={navLinkStyles}
                href="https://github.com/davidzenisu/game-gods-pet"
                target="_blank"
                rel="noreferrer noopener"
                aria-label="GitHub repository"
              >
                <svg
                  width="20"
                  height="20"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  aria-hidden="true"
                >
                  <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77 5.44 5.44 0 0 0 3.5 8.09c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22" />
                </svg>
              </a>
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
