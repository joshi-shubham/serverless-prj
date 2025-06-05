import pkg from '@aws-sdk/client-dynamodb';
const { DynamoDBClient, PutItemCommand } = pkg;
import { marshall } from '@aws-sdk/util-dynamodb';

const client = new DynamoDBClient();

export const handler = async (event) => {
 

    const timeToLive = new Date(event.TimeToLive).getTime() / 1000; // Convert to Unix timestamp in seconds

    const params = {
        TableName: 'remainders',
        Item: marshall({
            Id: Number(event.Id), // Ensure Id is a number
            userId: event.userId,
            TimeToLive: timeToLive, // TTL attribute
            message: event.message
        })
    };

    console.log('Params:', params); // Log the params to verify the data

    try {
        await client.send(new PutItemCommand(params));
        return { statusCode: 200, body: JSON.stringify({ message: 'Record created successfully!!!' }) };
    } catch (error) {
        console.error('Error creating record:', error);
        return { statusCode: 500, body: JSON.stringify({ message: 'Failed to create record', error }) };
    }
};
