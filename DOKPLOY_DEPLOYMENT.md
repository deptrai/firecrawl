# Firecrawl Self-Hosted Deployment with Dokploy

This repository contains the deployment configuration for self-hosting Firecrawl using Docker Compose, optimized for deployment via Dokploy.

## Overview

Firecrawl is a powerful web scraping and crawling API that converts websites into LLM-ready markdown or structured data. This deployment setup includes:

- **Firecrawl API**: Main application service
- **Playwright Service**: Handles JavaScript-heavy websites  
- **Redis**: Caching and queue management
- **PostgreSQL**: Data persistence

## Quick Deploy to Dokploy

1. **Create New Application in Dokploy**:
   - Go to your Dokploy dashboard
   - Click "Create Application"
   - Select "Docker Compose"
   - Enter repository URL: `https://github.com/deptrai/firecrawl.git`

2. **Configure Environment Variables**:
   - Update `.env` file with your settings:
     - `FIRECRAWL_DOMAIN`: Your domain name
     - `POSTGRES_PASSWORD`: Strong database password
     - Add API keys as needed (OpenAI, Anthropic, etc.)

3. **Deploy**:
   - Dokploy will automatically use Traefik for SSL termination
   - The service will be available at your configured domain

## Configuration

### Required Environment Variables

- `FIRECRAWL_DOMAIN`: Your domain for Traefik routing
- `POSTGRES_PASSWORD`: Database password (change from default!)

### Optional Environment Variables

- `OPENAI_API_KEY`: For AI-powered extraction features
- `ANTHROPIC_API_KEY`: Alternative AI provider
- `SUPABASE_*`: For user authentication
- `SERPER_API_KEY`: For web search functionality

## Features

### Core API Endpoints

- **POST /v2/scrape**: Scrape single URLs
- **POST /v2/crawl**: Crawl entire websites
- **POST /v2/search**: Web search with scraping
- **POST /v2/extract**: Extract structured data with AI

### Example Usage

```bash
# Scrape a single page
curl -X POST https://your-domain.com/v2/scrape \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "url": "https://example.com",
    "formats": ["markdown", "html"]
  }'

# Crawl an entire website
curl -X POST https://your-domain.com/v2/crawl \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "url": "https://example.com",
    "limit": 100,
    "scrapeOptions": {
      "formats": ["markdown"]
    }
  }'
```

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Traefik       │    │   Firecrawl API  │    │   Playwright    │
│   (SSL/Proxy)   ├────┤   (Port 3002)    ├────┤   Service       │
└─────────────────┘    └──────────┬───────┘    └─────────────────┘
                                   │
                         ┌─────────┼─────────┐
                         │                   │
                 ┌───────▼────────┐ ┌────────▼──────────┐
                 │     Redis      │ │   PostgreSQL      │
                 │   (Cache)      │ │   (Database)      │
                 └────────────────┘ └───────────────────┘
```

## Health Checks

All services include health checks:
- Redis: `redis-cli ping`
- PostgreSQL: `pg_isready`
- Playwright: HTTP health endpoint
- API: HTTP health endpoint

## Security Considerations

1. **Change Default Passwords**: Always update `POSTGRES_PASSWORD`
2. **Use Environment Variables**: Never commit secrets to git
3. **API Keys**: Store sensitive keys in Dokploy environment settings
4. **Firewall**: Ensure only necessary ports are exposed

## Monitoring

- Health checks ensure service availability
- Logs available via `docker logs` or Dokploy interface
- Consider adding monitoring tools like Prometheus + Grafana

## Scaling

- Increase `NUM_WORKERS_PER_QUEUE` for higher throughput
- Scale Playwright service horizontally for JavaScript-heavy workloads
- Use external Redis/PostgreSQL for production loads

## Support

- [Firecrawl Documentation](https://docs.firecrawl.dev/)
- [GitHub Repository](https://github.com/mendableai/firecrawl)
- [Dokploy Documentation](https://docs.dokploy.com/)

## License

Same as upstream Firecrawl project.