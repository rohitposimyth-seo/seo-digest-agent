#!/usr/bin/env bash
# SEO Digest — Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/YOURUSERNAME/seo-digest/main/install.sh | bash

set -e

REPO_RAW="https://raw.githubusercontent.com/rohitposimyth-seo/seo-digest-agent/main"
SKILLS_DIR="$HOME/.claude/skills"
CONFIG_DIR="$HOME/.claude/seo-digest"
REPORTS_DIR="$HOME/seo-digest/reports"

echo ""
echo "🔍 SEO Digest — Installing..."
echo ""

# ── Create directories ──────────────────────────────────────────────────────
mkdir -p "$SKILLS_DIR/seo-digest"
mkdir -p "$SKILLS_DIR/seo-digest-setup"
mkdir -p "$SKILLS_DIR/seo-digest-update"
mkdir -p "$CONFIG_DIR"
mkdir -p "$REPORTS_DIR"

# ── Download skill files ─────────────────────────────────────────────────────
echo "Downloading skills..."

curl -fsSL "$REPO_RAW/skills/seo-digest/SKILL.md"        -o "$SKILLS_DIR/seo-digest/SKILL.md"
curl -fsSL "$REPO_RAW/skills/seo-digest-setup/SKILL.md"  -o "$SKILLS_DIR/seo-digest-setup/SKILL.md"
curl -fsSL "$REPO_RAW/skills/seo-digest-update/SKILL.md" -o "$SKILLS_DIR/seo-digest-update/SKILL.md"

echo "✅ Skills installed"
echo ""

# ── Done ─────────────────────────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  SEO Digest is installed. Two more things:"
echo ""
echo "  1. Connect Google Search Console (required)"
echo "     Open Claude → Settings → Connectors"
echo "     → Google Search Console → Connect"
echo "     Authorize your Google account. Takes 60 seconds."
echo ""
echo "  2. Connect ClickUp (optional — for doc delivery)"
echo "     Same place: Settings → Connectors → ClickUp → Connect"
echo ""
echo "  3. Quit Claude Code fully and reopen it."
echo "     Mac: Cmd+Q  |  Windows: Alt+F4"
echo ""
echo "  4. Run: /seo-digest-setup"
echo "     Select your site, set delivery, optionally schedule Monday reports."
echo "     Takes 2 minutes."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Commands after setup:"
echo "    /seo-digest         → run digest now"
echo "    /seo-digest 14d     → last 14 days"
echo "    /seo-digest-update  → get latest version"
echo ""
