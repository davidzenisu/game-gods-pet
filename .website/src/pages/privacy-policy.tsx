import * as React from "react"
import { Link, type HeadFC, type PageProps, graphql } from "gatsby"
import Layout from "../components/layout"

const linkStyle = {
  color: "var(--accent)",
  fontWeight: 700,
  textDecoration: "none",
}

interface PrivacyPolicyPageData {
  markdownRemark: {
    html: string
  }
}

const PrivacyPolicyPage: React.FC<PageProps<PrivacyPolicyPageData>> = ({ data }) => {
  return (
    <Layout>
      <div className="markdown-content" dangerouslySetInnerHTML={{ __html: data.markdownRemark.html }} />

      <p style={{ marginTop: 32 }}>
        <Link style={linkStyle} to="/">← Back to home</Link>
      </p>
    </Layout>
  )
}

export default PrivacyPolicyPage

export const Head: HeadFC = () => <title>Privacy Policy | God&apos;s Pet</title>

export const query = graphql`
  query {
    markdownRemark(fileAbsolutePath: { regex: "/privacy.md$/" }) {
      html
    }
  }
`
