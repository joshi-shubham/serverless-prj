// sendMessage.mjs
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";

const FROM_EMAIL = "bounce@devopswithshubham.com"; // Must be verified in SES
const REGION = "ca-central-1"; // Replace with your SES region

const sesClient = new SESClient({ region: REGION });

export const handler = async (event) => {
  for (const record of event.Records) {
    if (record.eventName === "INSERT") {
      const newImage = record.dynamodb?.NewImage;

      if (!newImage || !newImage.userId || !newImage.message) {
        console.warn("Missing NewImage or required fields:", record);
        continue;
      }

      const email = newImage.userId.S;
      const message = newImage.message.S;


      const params = {
        Source: FROM_EMAIL,
        Destination: {
          ToAddresses: [email],
        },
        Message: {
          Subject: {
            Data: "Your Reminder",
          },
          Body: {
            Text: {
              Data: message,
            },
          },
        },
      };

      try {
        const command = new SendEmailCommand(params);
        const response = await sesClient.send(command);
        console.log(`Email sent to ${email}:`, response);
      } catch (error) {
        console.error("Failed to send email:", error);
      }
    }
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Processing complete" }),
  };
};
