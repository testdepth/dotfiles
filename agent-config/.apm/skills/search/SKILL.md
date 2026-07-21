---
name: search
description: Semantic search across the wiki with synthesized answers and source citations.
allowed-tools: Read Glob Grep
argument-hint: "<query>"
---

# Wiki Search

Semantic search across the wiki with synthesized answers.

## Configuration
```
VAULT_PATH="/Users/shark/Library/Mobile Documents/com~apple~CloudDocs/sharkvault"
```

All file operations use paths relative to VAULT_PATH.

## Usage
```
/search <query>
```

## Arguments
- `query`: Natural language search query

## Process

### 1. Parse Query
- Identify key terms and concepts
- Determine likely domains (work, business, personal, or all)
- Identify entity types if mentioned (people, companies, prospects, etc.)

### 2. Search Strategy

#### Filename Search
- Search for query terms in filenames
- Prioritize exact matches

#### Content Search
- Search file contents for query terms
- Use grep/ripgrep for efficient scanning
- Weight matches in:
  - Title (highest)
  - Frontmatter tags
  - Headers
  - Body text

#### Frontmatter Search
- Search YAML frontmatter fields
- Useful for: status, tags, entity types, dates

### 3. Rank Results
Score each matching file:
- Exact title match: +10
- Query term in title: +5
- Query term in tags: +3
- Query term in headers: +2
- Query term in body: +1
- Recent file (last 30 days): +2
- Multiple query terms present: multiply score

### 4. Synthesize Answer

Read top 5-10 relevant files and synthesize:
```markdown
## Answer

{Direct answer to the query based on wiki content}

## Sources

Based on {X} wiki pages:

### Most Relevant
- [[source-1]]: {brief relevance summary}
- [[source-2]]: {brief relevance summary}

### Also Related
- [[source-3]]
- [[source-4]]

## Key Information

{Extracted facts, quotes, or data points that answer the query}

## Gaps

{Note any aspects of the query not covered by wiki content}
```

### 5. Domain-Specific Searches

#### CRM Search
For queries about prospects/clients:
- Search `wiki/business/entities/prospects/`
- Search `wiki/business/entities/clients/`
- Include status and value info in results

#### Service Search
For queries about services/offerings:
- Search `wiki/business/entities/services/`
- Include pricing and deliverables in results

#### Entity Search
For queries about people/companies:
- Search all `entities/` folders
- Show relationships and source count

### 6. Empty Results
If no matches found:
```markdown
## No Results

No wiki pages match "{query}".

### Suggestions
- Try different keywords
- Check if this topic exists in raw/ but hasn't been ingested
- Consider what domain this might belong to
```

## Example Queries

| Query | Search Focus |
|-------|--------------|
| "John Smith" | Entities (person type) |
| "hot prospects" | Prospects with status=hot |
| "kubernetes" | Concepts and sources with this term |
| "proposal for Acme" | Proposals mentioning Acme |
| "what do we know about Company X" | All pages mentioning Company X |
| "recent meetings" | Sources with type=meeting, recent dates |

## Output Format

Always provide:
1. Direct answer (if possible)
2. Source citations with wikilinks
3. Key extracted information
4. Note on gaps or limitations

## Performance

- Limit content search to `{VAULT_PATH}/wiki/` directory
- Use file type filtering (.md only)
- Cache recent search results (5 minute TTL)
- Stop after finding 20 potential matches for ranking

## No Logging
Search operations are read-only and not logged to log.md.
