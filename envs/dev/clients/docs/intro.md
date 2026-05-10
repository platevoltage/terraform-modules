# Site-to-Site VPN — Customer Onboarding Information Request

To provision your dedicated AWS Site-to-Site VPN connection, we require the following technical details from your network team. Please complete all sections and return this document to your Space Rocket contact.

---

## 1. Organization

| Field | Your Value |
|---|---|
| Company name | |
| Primary network contact name | |
| Primary network contact email | |
| Primary network contact phone | |

---

## 2. Primary Site — VPN Termination

The primary site is your main data center or network location that will terminate the VPN tunnel.

| Field | Your Value | Notes |
|---|---|---|
| VPN device public IP address | | Static IP required |
| On-premises network CIDR | | e.g. `10.0.0.0/16` |
| VPN device make and model | | e.g. Cisco ASA 5506, Palo Alto PA-220 |
| VPN device software version | | |

---

## 3. DR Site — VPN Termination

The DR site is your disaster recovery or secondary location. A separate VPN connection will be provisioned for resilience.

| Field | Your Value | Notes |
|---|---|---|
| VPN device public IP address | | Static IP required |
| On-premises network CIDR | | May be same or different from primary |
| VPN device make and model | | |
| VPN device software version | | |

---

## 4. Routing

| Field | Your Value | Notes |
|---|---|---|
| Routing preference | BGP / Static | BGP strongly preferred |
| BGP ASN | | Your AS number. Request one from us if you don't have one. |

If using **BGP**, no further routing information is needed — prefixes will be exchanged dynamically.

If using **static routing**, list all on-premises CIDRs to be reachable over the VPN:

| CIDR | Description |
|---|---|
| | |
| | |

---

## 5. Tunnel Configuration

We provision two tunnels per VPN connection (primary and DR) for high availability. Both tunnels use the same cryptographic policy. Please confirm the following are acceptable or provide alternatives.

### IKE

| Parameter | Our Default | Your Preference |
|---|---|---|
| IKE version | IKEv2 | |
| Phase 1 encryption | AES-256, AES-256-GCM-16 | |
| Phase 1 integrity | SHA2-256, SHA2-384, SHA2-512 | |
| Phase 1 DH group | 14, 19, 20, 21 | |
| Phase 1 lifetime | 28800 seconds | |

### IPsec

| Parameter | Our Default | Your Preference |
|---|---|---|
| Phase 2 encryption | AES-256, AES-256-GCM-16 | |
| Phase 2 integrity | SHA2-256, SHA2-384, SHA2-512 | |
| Phase 2 DH group (PFS) | 14, 19, 20, 21 | |
| Phase 2 lifetime | 3600 seconds | |

> **Note:** IKEv1 is not supported. All algorithms must be from the lists above or from [AWS supported values](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html).

---

## 6. Pre-Shared Key (PSK)

AWS generates PSKs automatically. We will share them securely via an encrypted channel after provisioning. If you require a specific PSK, it must meet the following requirements:

- 8–64 characters
- Alphanumeric, periods, and underscores only
- Cannot start with zero (0)

| Field | Your Value |
|---|---|
| Provide your own PSK? | Yes / No |
| PSK (primary tunnel 1) | |
| PSK (primary tunnel 2) | |
| PSK (DR tunnel 1) | |
| PSK (DR tunnel 2) | |

---

## 7. Additional Notes

Please use this space to describe any firewall rules, NAT configurations, or other constraints we should be aware of:

```
(free text)
```

---

*Return completed form to your Space Rocket account team. Configuration will be provisioned within 2 business days of receiving all required information.*
