import * as React from "react"
import { type HeadFC, type PageProps, graphql } from "gatsby"
import Layout from "../components/layout"
import { StaticImage } from "gatsby-plugin-image"

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

const IndexPage: React.FC<PageProps<IndexPageData>> = ({ data }) => {
  return (
    <Layout>
      <div style={screenshotGridStyles}>
        <StaticImage style={screenshotStyles} src="../images/screenshot_1.png" alt="Screenshot placeholder 1" />
        <StaticImage style={screenshotStyles} src="../images/screenshot_3.png" alt="Screenshot placeholder 2" />
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
