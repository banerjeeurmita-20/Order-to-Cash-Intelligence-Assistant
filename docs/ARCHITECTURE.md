# Architecture Overview

## Data flow

1. **Ingestion (ADF)**  
   - **Structured:** Orders, invoices, payments, customers from ERP/CRM (API or file export) → landing in Blob/ADLS → load into Azure SQL.  
   - **Unstructured:** Contract/quote PDFs from Blob/SharePoint → landing in Blob (e.g. `raw/contracts/`).

2. **Structured store (Azure SQL)**  
   - Tables: `customers`, `orders`, `order_line_items`, `invoices`, `payments`.  
   - Supports queries like: orders pending approval, invoices overdue, payment terms by customer.

3. **Document pipeline (Databricks)**  
   - Read PDFs from Blob → extract text → chunk by section (terms, pricing, clauses) → generate embeddings (e.g. Azure OpenAI / HuggingFace) → write to vector store (e.g. Azure AI Search or Databricks Vector Search).  
   - Optional: store chunk metadata (document_id, customer_id, section) for filtered retrieval.

4. **Query layer (App)**  
   - User asks in natural language.  
   - **SQL path:** “Orders pending approval,” “Invoices overdue” → query Azure SQL.  
   - **RAG path:** “Payment terms for customer X,” “Why was invoice Y disputed?” → retrieve from vector store + LLM summary.  
   - **Hybrid:** Combine SQL result + RAG context when needed.

## Components (to be built)

- **sql/** – DDL and migrations for Azure SQL.  
- **adf/** – ADF pipeline definitions (ARM templates or exported JSON).  
- **databricks/** – Notebooks/jobs for document processing and embedding pipeline.  
- **app/** – Simple UI or API that calls SQL + RAG (e.g. Streamlit, FastAPI, or notebook).
