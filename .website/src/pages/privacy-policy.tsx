import * as React from "react"
import { Link, type HeadFC, type PageProps } from "gatsby"
import Layout from "../components/layout"

const headingStyles = {
  marginTop: 0,
  marginBottom: 16,
  fontSize: "2.5rem",
  lineHeight: 1.05,
}
const sectionHeadingStyles = {
  marginBottom: 12,
  fontSize: "1.2rem",
  color: "var(--text)",
}
const paragraphStyles = {
  marginBottom: 24,
  color: "var(--muted)",
  fontSize: "1rem",
  lineHeight: 1.75,
}
const linkStyle = {
  color: "var(--accent)",
  fontWeight: 700,
  textDecoration: "none",
}

const PrivacyPolicyPage: React.FC<PageProps> = () => {
  return (
    <Layout>
      <h1 style={headingStyles}>Privacy Policy</h1>
      <p style={paragraphStyles}>
        God&apos;s Pet respects your privacy. This page explains what information is collected when you visit the website and how that information is used.
      </p>

      <div>
        <h2 style={sectionHeadingStyles}>Information collected</h2>
        <p style={paragraphStyles}>
          We do not collect personal data through this website unless you explicitly provide it, for example via contact or download request forms. Any third-party services integrated into the site may collect browser and usage information independently.
        </p>
      </div>

      <div>
        <h2 style={sectionHeadingStyles}>Use of information</h2>
        <p style={paragraphStyles}>
          Information collected is used to improve the website experience, troubleshoot issues, and publish updates about the game. We do not sell or share your personal data with unaffiliated third parties.
        </p>
      </div>

      <div>
        <h2 style={sectionHeadingStyles}>Cookies and analytics</h2>
        <p style={paragraphStyles}>
          Cookies may be used by hosting or analytics providers to understand traffic patterns and maintain site performance. Those cookies do not identify you personally.
        </p>
      </div>

      <p style={paragraphStyles}>
        For questions about privacy, please contact the site owner through the project repository.
      </p>

      <p>
        <Link style={linkStyle} to="/">← Back to home</Link>
      </p>
    </Layout>
  )
}

export default PrivacyPolicyPage

export const Head: HeadFC = () => <title>Privacy Policy | God&apos;s Pet</title>
