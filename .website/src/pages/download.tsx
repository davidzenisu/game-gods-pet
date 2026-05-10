import * as React from "react"
import { Link, type HeadFC, type PageProps } from "gatsby"
import Layout from "../components/layout"

const paragraphStyles = {
  marginBottom: 24,
  color: "var(--muted)",
  fontSize: "1rem",
  lineHeight: 1.75,
}

const DownloadPage: React.FC<PageProps> = () => {
  return (
    <Layout>
      <h1>Download God&apos;s Pet</h1>
      <p>
        Access the latest builds and install notes for God&apos;s Pet. Download options are updated as new versions become available.
      </p>

      <ul>
        <li>Windows build: Coming soon</li>
        <li>macOS build: Coming soon</li>
        <li>Android / iOS: Coming soon</li>
      </ul>

      <p style={paragraphStyles}>
        If you want the latest updates on release status, follow the project repository and visit this page regularly.
      </p>

      <p>
        <Link to="/">← Back to home</Link>
      </p>
      <p>
        <Link to="/privacy-policy">Read the privacy policy</Link>
      </p>
    </Layout>
  )
}

export default DownloadPage

export const Head: HeadFC = () => <title>Download | God&apos;s Pet</title>
