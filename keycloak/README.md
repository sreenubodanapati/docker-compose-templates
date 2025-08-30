# Keycloak Docker Compose

Identity and Access Management platform with:
- **Keycloak** server for authentication
- **PostgreSQL** database backend
- **MailHog** for email testing
- Demo application integration

## Quick Start

1. Update secrets:
   ```bash
   echo "your_admin_password" > secrets/keycloak_admin_password.txt
   echo "your_postgres_password" > secrets/postgres_password.txt
   ```

2. Start Keycloak:
   ```bash
   docker-compose up -d
   ```

3. With demo app and mail server:
   ```bash
   docker-compose --profile demo --profile mail up -d
   ```

## Access
- Keycloak Admin: http://localhost:8080
- Keycloak HTTPS: https://localhost:8443
- Demo App: http://localhost:3000 (demo profile)
- MailHog UI: http://localhost:8025 (mail profile)
- Default login: admin / (password from secrets file)

## Configuration

### Environment Variables
- `KEYCLOAK_ADMIN_USER`: Admin username (default: admin)
- `KEYCLOAK_HOSTNAME`: Server hostname (default: localhost)
- `KEYCLOAK_PORT`: HTTP port (default: 8080)
- `KEYCLOAK_HTTP_ENABLED`: Enable HTTP (default: true)
- `KEYCLOAK_PROXY`: Proxy mode (edge/reencrypt/passthrough)
- `POSTGRES_USER`: Database user (default: keycloak)
- `POSTGRES_DB`: Database name (default: keycloak)

## Realm Configuration

### Import Realm
Place realm export in `config/realm-export.json` for automatic import.

### Sample Realm Configuration
```json
{
  "realm": "demo",
  "enabled": true,
  "registrationAllowed": true,
  "resetPasswordAllowed": true,
  "verifyEmail": true,
  "clients": [
    {
      "clientId": "demo-app",
      "enabled": true,
      "publicClient": true,
      "redirectUris": ["http://localhost:3000/*"],
      "webOrigins": ["http://localhost:3000"]
    }
  ]
}
```

## Authentication Methods

### Supported Protocols
- **OpenID Connect (OIDC)**
- **SAML 2.0**
- **OAuth 2.0**

### Identity Providers
Configure external providers:
- Google
- GitHub
- Microsoft Azure AD
- LDAP/Active Directory
- Custom OIDC providers

## Client Integration

### JavaScript/Node.js
```javascript
const Keycloak = require('keycloak-connect');
const keycloak = new Keycloak({}, {
  realm: 'demo',
  'auth-server-url': 'http://localhost:8080/',
  'ssl-required': 'external',
  resource: 'demo-app',
  'public-client': true
});
```

### Spring Boot
```yaml
keycloak:
  auth-server-url: http://localhost:8080/
  realm: demo
  resource: demo-app
  public-client: true
```

### Python/Django
```python
KEYCLOAK_CONFIG = {
    'KEYCLOAK_SERVER_URL': 'http://localhost:8080/',
    'KEYCLOAK_REALM': 'demo',
    'KEYCLOAK_CLIENT_ID': 'demo-app',
    'KEYCLOAK_CLIENT_PUBLIC': True,
}
```

## User Management

### Create Users
1. Admin Console → Users
2. Add User
3. Set credentials
4. Assign roles

### User Registration
Enable self-registration:
1. Realm Settings → Login
2. Enable "User registration"
3. Configure email verification

## Themes & Branding

### Custom Themes
1. Create theme in `themes/` directory
2. Configure in realm settings
3. Customize login pages, emails, admin console

### Example Theme Structure
```
themes/
└── custom-theme/
    ├── login/
    ├── account/
    ├── admin/
    └── email/
```

## Single Sign-On (SSO)

### OIDC Configuration
```json
{
  "auth-server-url": "http://localhost:8080/",
  "realm": "demo",
  "resource": "client-id",
  "public-client": true,
  "ssl-required": "external"
}
```

### SAML Configuration
- Entity ID: `http://localhost:8080/realms/demo`
- SSO URL: `http://localhost:8080/realms/demo/protocol/saml`
- Logout URL: `http://localhost:8080/realms/demo/protocol/saml`

## Production Setup

1. **Security**:
   - Enable HTTPS only
   - Configure proper hostname
   - Use external database
   - Set up backup strategy

2. **Performance**:
   - Configure JVM options
   - Enable clustering for HA
   - Use external cache (Infinispan)

3. **Monitoring**:
   - Enable metrics endpoint
   - Configure logging
   - Set up health checks

4. **Email**:
   - Configure SMTP server
   - Test email delivery
   - Customize email templates

## High Availability

For production HA setup:
```yaml
keycloak-1:
  # ... keycloak config
  environment:
    - KC_CACHE=ispn
    - KC_CACHE_STACK=kubernetes

keycloak-2:
  # ... keycloak config (same as above)
```

## Troubleshooting

- Check startup logs: `docker-compose logs keycloak`
- Verify database connectivity
- Test email configuration with MailHog
- Check realm import status
- Validate client configurations
