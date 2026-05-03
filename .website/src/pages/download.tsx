import * as React from "react"
import { Link, type HeadFC, type PageProps } from "gatsby"
import Layout from "../components/layout"

const headingStyles = {
  marginTop: 0,
  marginBottom: 16,
  fontSize: "2.5rem",
  lineHeight: 1.05,
}
const paragraphStyles = {
  marginBottom: 24,
  color: "var(--muted)",
  fontSize: "1rem",
  lineHeight: 1.75,
}
const listStyles = {
  listStyle: "none",
  paddingLeft: 0,
  margin: "0 auto 32px",
  maxWidth: 420,
  textAlign: "left" as const,
}
const listItemStyles = {
  padding: "10px 0",
  borderBottom: "1px solid var(--border)",
}
const screenshotStyles = {
  width: "100%",
  borderRadius: 22,
  border: "1px solid var(--border)",
  backgroundColor: "rgba(255,255,255,0.6)",
  marginBottom: 32,
}
const linkStyle = {
  color: "var(--accent)",
  fontWeight: 700,
  textDecoration: "none",
}

const screenshotData =
  "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='800' height='500' viewBox='0 0 800 500'%3E%3Crect width='800' height='500' rx='32' fill='%23f8fafc'/%3E%3Crect x='40' y='40' width='720' height='320' rx='28' fill='%23e2e8f0'/%3E%3Crect x='60' y='380' width='340' height='22' rx='11' fill='%23cbd5e1'/%3E%3Crect x='60' y='422' width='200' height='18' rx='9' fill='%23cbd5e1'/%3E%3Ctext x='400' y='220' text-anchor='middle' dominant-baseline='middle' fill='%2338475e' font-family='Inter, system-ui, sans-serif' font-size='36'%3EDownload Preview%3C/text%3E%3C/svg%3E"

const DownloadPage: React.FC<PageProps> = () => {
  return (
    <Layout>
      <h1 style={headingStyles}>Download God&apos;s Pet</h1>
      <p style={paragraphStyles}>
        Access the latest builds and install notes for God&apos;s Pet. Download options are updated as new versions become available.
      </p>

      <img style={screenshotStyles} src={screenshotData} alt="Download page placeholder screenshot" />

      <ul style={listStyles}>
        <li style={listItemStyles}>Windows build: Coming soon</li>
        <li style={listItemStyles}>macOS build: Coming soon</li>
        <li style={listItemStyles}>Android / iOS: Coming soon</li>
      </ul>

      <p style={paragraphStyles}>
        If you want the latest updates on release status, follow the project repository and visit this page regularly.
      </p>

      <p>
        <Link style={linkStyle} to="/">← Back to home</Link>
      </p>
      <p>
        <Link style={linkStyle} to="/privacy-policy">Read the privacy policy</Link>
      </p>
    </Layout>
  )
}

export default DownloadPage

export const Head: HeadFC = () => <title>Download | God&apos;s Pet</title>
