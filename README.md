# Order-to-Cash Intelligence Assistant

A portfolio project demonstrating **Data Engineering with AI integration** on Azure: multi-source ingestion (Azure Data Factory), structured data (Azure SQL DB), document processing and embeddings (Databricks), and natural-language query over orders, invoices, and contract terms via a **DB-RAG** pattern (structured SQL + vector RAG).

## Tech stack

| Component        | Role                                                                 |
|-----------------|----------------------------------------------------------------------|
| **Azure Data Factory** | Ingest orders, invoices, payments, customers; contract/quote PDFs from Blob. |
| **Azure SQL DB**       | Structured store: orders, invoices, payments, customers, order_line_items.   |
| **Databricks**        | Document parsing, chunking, embedding pipeline; write to vector store.       |
| **RAG / LLM**         | Hybrid query: SQL for metrics + vector RAG over contract/quote text.          |

## Architecture (high level)

```
[ERP/CRM / Blob] --> ADF --> [Azure SQL] --> App (SQL + RAG)
        |                          ^
        v                          |
   [Blob PDFs] --> Databricks --> [Vector store] --> App
```

## Repo structure

```
order-to-cash-intelligence/
├── README.md           # This file
├── docs/               # Architecture, runbooks
├── sql/                # DDL, migrations for Azure SQL
├── adf/                # ADF pipelines (ARM or export)
├── databricks/         # Notebooks, job configs
├── app/                # Query layer (e.g. Streamlit / FastAPI)
├── data/               # Sample data (raw, curated)
│   ├── raw/
│   └── curated/
└── scripts/            # Utility scripts
```

## Project steps (implementation order)

| Step | Description                    | Status   |
|------|--------------------------------|----------|
| 1    | Project setup & GitHub        | Done     |
| **2** | Data model (Azure SQL DDL)    | **Done** |
| 3    | Sample / mock data            | Pending  |
| 4    | Azure Data Factory – ingestion | Pending  |
| 5    | Databricks – document pipeline | Pending  |
| 6    | RAG / app layer               | Pending  |
| 7    | End-to-end & documentation    | Pending  |

## Getting started

1. Clone the repo (after pushing to GitHub):  
   `git clone https://github.com/<your-username>/order-to-cash-intelligence.git`
2. See `docs/ARCHITECTURE.md` for a bit more detail on data flow.
3. Follow the steps above in order; each step has its own folder and instructions.

## License

MIT (or your choice).
