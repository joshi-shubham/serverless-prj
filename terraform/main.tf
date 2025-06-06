

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
    stream_enabled = true
    stream_view_type = "NEW_AND_OLD_IMAGES"
}
