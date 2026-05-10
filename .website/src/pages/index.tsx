import * as React from "react"
import { type HeadFC, type PageProps, graphql } from "gatsby"
import Layout from "../components/layout"

const screenshotGridStyles = {
  display: "grid",
  gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))",
  gap: 20,
  marginTop: 20,
  marginBottom: 60,
}
const screenshotStyles = {
  width: "100%",
  borderRadius: 22,
  border: "1px solid var(--border)",
  backgroundColor: "rgba(255,255,255,0.6)",
  minHeight: 180,
}

interface IndexPageData {
  markdownRemark: {
    html: string
  }
}

const screenshot1 =
  "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='420' viewBox='0 0 640 420'%3E%3Crect width='640' height='420' rx='28' fill='%23eef2ff'/%3E%3Crect x='28' y='28' width='584' height='260' rx='24' fill='%23e2e8f0'/%3E%3Crect x='48' y='308' width='320' height='22' rx='11' fill='%23cbd5e1'/%3E%3Crect x='48' y='348' width='180' height='18' rx='9' fill='%23cbd5e1'/%3E%3Ctext x='320' y='210' text-anchor='middle' dominant-baseline='middle' fill='%23473fce' font-family='Inter, system-ui, sans-serif' font-size='32'%3EScreenshot 1%3C/text%3E%3C/svg%3E"

const screenshot2 =
  "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='420' viewBox='0 0 640 420'%3E%3Crect width='640' height='420' rx='28' fill='%23f8fafc'/%3E%3Crect x='28' y='28' width='584' height='260' rx='24' fill='%23e2e8f0'/%3E%3Crect x='48' y='308' width='320' height='22' rx='11' fill='%23cbd5e1'/%3E%3Crect x='48' y='348' width='180' height='18' rx='9' fill='%23cbd5e1'/%3E%3Ctext x='320' y='210' text-anchor='middle' dominant-baseline='middle' fill='%2338475e' font-family='Inter, system-ui, sans-serif' font-size='32'%3EScreenshot 2%3C/text%3E%3C/svg%3E"

const IndexPage: React.FC<PageProps<IndexPageData>> = ({ data }) => {
  return (
    <Layout>
      <div style={screenshotGridStyles}>
        <img style={screenshotStyles} src={screenshot1} alt="Screenshot placeholder 1" />
        <img style={screenshotStyles} src={screenshot2} alt="Screenshot placeholder 2" />
      </div>

      <div className="markdown-content" dangerouslySetInnerHTML={{ __html: data.markdownRemark.html }} />
    </Layout>
  )
}

export default IndexPage

export const Head: HeadFC = () => <title>Home | God&apos;s Pet</title>

export const query = graphql`
  query {
    markdownRemark(fileAbsolutePath: { regex: "/home.md$/" }) {
      html
    }
  }
`
