import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { GetItemCommand } from "@aws-sdk/client-dynamodb";
import { unmarshall } from "@aws-sdk/util-dynamodb";

const client = new DynamoDBClient();

export const handler = async (event) => {
    const params = {
        TableName: 'remainders',
        Key: {
            Id: { N: String(event.Id) } // Ensure Id is a number in string format
        }
    };

    try {
        const data = await client.send(new GetItemCommand(params));
        if (data.Item) {
            const item = unmarshall(data.Item);
            return { statusCode: 200, body: JSON.stringify(item) };
        } else {
            return { statusCode: 404, body: JSON.stringify({ message: 'Record not found' }) };
        }
    } catch (error) {
        console.error('Error retrieving record:', error);
        return { statusCode: 500, body: JSON.stringify({ message: 'Failed to retrieve record', error }) };
    }
};
