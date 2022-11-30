locals {
  is_server_flex_shape = regex("Flex", var.server_shape_name) == "Flex" ? [1] : []
  is_agent_flex_shape  = regex("Flex", var.agent_shape_name) == "Flex" ? [1] : []
}