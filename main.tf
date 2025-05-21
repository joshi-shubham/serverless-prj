

resource "aws_dynamodb_table" "remainder-table"{
    name = "remainders"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "Id"
    attribute {
        name = "Id"
        type = "N"
    }
    
    ttl {
      attribute_name = "TimeToLive"
      enabled = true
    }

}
