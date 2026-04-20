import os
import ssl

import paho.mqtt.client as mqtt

# Configurare
BROKER = "127.0.0.1"
PORT = 8883  # Port securizat

PROJECT_ROOT = "/Users/dmonea/facultate/sric/ss/ss-web"

# Căile către certificate
SECRETS_DIR = os.path.join(PROJECT_ROOT, "secrets")
CA_CRT = os.path.join(SECRETS_DIR, "ca.crt")
CLIENT_CRT = os.path.join(SECRETS_DIR, "web.crt")
CLIENT_KEY = os.path.join(SECRETS_DIR, "web.key")

# Crearea clientului MQTT
client = mqtt.Client(client_id="device-id")

# Configurarea TLS
client.tls_set(
    ca_certs=CA_CRT,
    certfile=CLIENT_CRT,
    keyfile=CLIENT_KEY,
    tls_version=ssl.PROTOCOL_TLSv1_2,
)
# Omiterea verificării hostname-ului pentru testarea locală
client.tls_insecure_set(True)

# Conectare
client.connect(BROKER, PORT, 60)
