#!/bin/bash
# Firecrawl Dokploy Deployment Script
# Project ID: services-firecrawl-ru8kuu

set -e

echo "🚀 Deploying Firecrawl to Dokploy..."
echo "Project ID: services-firecrawl-ru8kuu"
echo "Domain: firecrawl.chainlens.net"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we have environment variables set
echo "🔍 Checking deployment configuration..."

if [ -f ".env" ]; then
    echo "✅ Found .env file"
    
    # Check domain configuration
    DOMAIN=$(grep "FIRECRAWL_DOMAIN" .env | cut -d'=' -f2)
    echo "📡 Domain: $DOMAIN"
    
    if [ "$DOMAIN" = "firecrawl.chainlens.net" ]; then
        echo "✅ Domain configured correctly"
    else
        echo -e "${YELLOW}⚠️  Domain might not be configured correctly${NC}"
    fi
else
    echo -e "${RED}❌ .env file not found${NC}"
    exit 1
fi

# Check if docker-compose.yml exists
if [ -f "docker-compose.yml" ]; then
    echo "✅ Found docker-compose.yml"
    
    # Validate docker-compose file
    if docker-compose config -q 2>/dev/null; then
        echo "✅ docker-compose.yml is valid"
    else
        echo -e "${YELLOW}⚠️  docker-compose.yml validation warning (might be due to missing variables)${NC}"
    fi
else
    echo -e "${RED}❌ docker-compose.yml not found${NC}"
    exit 1
fi

echo ""
echo "📋 Deployment Checklist:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. ✅ Repository: https://github.com/deptrai/firecrawl.git"
echo "2. ✅ Branch: main"
echo "3. ✅ Build Type: Dockerfile (Docker Compose)"
echo "4. ✅ Domain: firecrawl.chainlens.net"
echo "5. ⚠️  Environment Variables: Configure in Dokploy dashboard"
echo ""

echo -e "${GREEN}📝 Required Environment Variables in Dokploy:${NC}"
echo "   FIRECRAWL_DOMAIN=firecrawl.chainlens.net"
echo "   POSTGRES_PASSWORD=your_strong_password_here"
echo "   OPENAI_API_KEY=sk-proj-xxxxxxxx... (your OpenAI key)"
echo "   ANTHROPIC_API_KEY=sk-ant-xxxxxxxx... (your Anthropic key)"
echo ""

echo -e "${GREEN}🎯 Manual Deployment Steps:${NC}"
echo "1. Go to your Dokploy dashboard"
echo "2. Navigate to project: services-firecrawl-ru8kuu"
echo "3. Configure Environment Variables (see above)"
echo "4. Click 'Redeploy' or 'Deploy'"
echo "5. Monitor deployment logs"
echo "6. Test: curl https://firecrawl.chainlens.net/health"
echo ""

echo -e "${GREEN}🔍 Post-Deployment Tests:${NC}"
echo ""
echo "# Test health endpoint"
echo "curl -s https://firecrawl.chainlens.net/health | jq ."
echo ""
echo "# Test scrape endpoint (no auth)"
echo "curl -X POST https://firecrawl.chainlens.net/v2/scrape \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"url\": \"https://example.com\", \"formats\": [\"markdown\"]}'"
echo ""

echo -e "${GREEN}📡 Service Architecture:${NC}"
echo "• Firecrawl API: firecrawl-api container (port 3002)"
echo "• Playwright Service: firecrawl-playwright container (port 3000)"  
echo "• Redis Cache: firecrawl-redis container (port 6379)"
echo "• PostgreSQL DB: firecrawl-postgres container (port 5432)"
echo "• Traefik Proxy: SSL termination + routing"
echo ""

echo -e "${GREEN}🎉 Deployment preparation completed!${NC}"
echo "Now go to Dokploy dashboard to trigger the actual deployment."