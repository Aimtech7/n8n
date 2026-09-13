# Custom n8n Nodes

This directory contains custom nodes for this n8n deployment.

## Structure

```
custom-nodes/
├── package.json
└── nodes/
    └── ExampleNode/
        └── ExampleNode.node.ts   ← Your node logic
```

## Creating a New Node

1. Copy `nodes/ExampleNode/` to `nodes/YourNodeName/`
2. Rename and edit `YourNodeName.node.ts`
3. Register it in `package.json` under `n8n.nodes`

## Building

```bash
cd custom-nodes
npm install
npm run build
```

## Loading into n8n

**Docker Compose:**
```bash
# Mount the built dist/ into the container
# Add to docker-compose.yml volumes:
#   - ./custom-nodes/dist:/home/node/.n8n/custom/dist
```

Or uncomment the `COPY` line in the `Dockerfile` to bake nodes into the image.

## Resources

- [n8n Node Development Guide](https://docs.n8n.io/integrations/creating-nodes/)
- [n8n Community Nodes](https://www.npmjs.com/search?q=n8n-community-node)
