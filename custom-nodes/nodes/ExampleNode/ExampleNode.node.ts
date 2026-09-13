import {
  IExecuteFunctions,
  INodeExecutionData,
  INodeType,
  INodeTypeDescription,
  NodeOperationError,
} from 'n8n-workflow';

export class ExampleNode implements INodeType {
  description: INodeTypeDescription = {
    displayName: 'Example Node',
    name: 'exampleNode',
    icon: 'fa:star',
    group: ['transform'],
    version: 1,
    description: 'A starter custom node — replace with your own logic',
    defaults: {
      name: 'Example Node',
    },
    inputs: ['main'],
    outputs: ['main'],
    properties: [
      {
        displayName: 'Message',
        name: 'message',
        type: 'string',
        default: 'Hello from custom node!',
        description: 'The message to add to each item',
      },
    ],
  };

  async execute(this: IExecuteFunctions): Promise<INodeExecutionData[][]> {
    const items = this.getInputData();
    const returnData: INodeExecutionData[] = [];

    for (let i = 0; i < items.length; i++) {
      try {
        const message = this.getNodeParameter('message', i) as string;

        returnData.push({
          json: {
            ...items[i].json,
            customMessage: message,
            processedAt: new Date().toISOString(),
          },
        });
      } catch (error) {
        if (this.continueOnFail()) {
          returnData.push({ json: { error: (error as Error).message } });
          continue;
        }
        throw new NodeOperationError(this.getNode(), error as Error, { itemIndex: i });
      }
    }

    return [returnData];
  }
}
