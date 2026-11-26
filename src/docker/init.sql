CREATE TABLE IF NOT EXISTS hardware_telemetry_history (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    server_id VARCHAR(50) NOT NULL,
    serial_number VARCHAR(50) NOT NULL,
    rack_location VARCHAR(50),
    cpu_temp_celsius NUMERIC(5, 2),
    fan_rpm INTEGER,
    power_watts INTEGER,
    reallocated_sector_ct INTEGER DEFAULT 0,
    pending_sector_ct INTEGER DEFAULT 0,
    health_status VARCHAR(20) DEFAULT 'OK', -- 'OK', 'WARNING', 'CRITICAL'
    internal_ip_anon VARCHAR(50),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_telemetry_server_id ON hardware_telemetry_history(server_id);
CREATE INDEX IF NOT EXISTS idx_telemetry_timestamp ON hardware_telemetry_history(timestamp);
CREATE INDEX IF NOT EXISTS idx_telemetry_rack ON hardware_telemetry_history(rack_location);

CREATE TABLE IF NOT EXISTS hardware_critical_alerts (
    alert_id SERIAL PRIMARY KEY,
    detected_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    server_id VARCHAR(50) NOT NULL,
    serial_number VARCHAR(50) NOT NULL,
    rack_location VARCHAR(50),
    alert_type VARCHAR(50) NOT NULL,        -- 'DISK_HEALTH_FAIL', 'THERMAL_RISK', 'POWER_ANOMALY'
    severity VARCHAR(20) NOT NULL,          -- 'WARNING', 'CRITICAL'
    details TEXT,
    warranty_active BOOLEAN DEFAULT FALSE,
    rma_eligible BOOLEAN DEFAULT FALSE,
    vendor VARCHAR(100),
    resolved BOOLEAN DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS idx_alerts_server_id ON hardware_critical_alerts(server_id);
CREATE INDEX IF NOT EXISTS idx_alerts_severity ON hardware_critical_alerts(severity);
CREATE INDEX IF NOT EXISTS idx_alerts_rma ON hardware_critical_alerts(rma_eligible);

CREATE TABLE IF NOT EXISTS datacenter_inventory (
    server_id VARCHAR(50) PRIMARY KEY,
    serial_number VARCHAR(50) UNIQUE NOT NULL,
    mac_address VARCHAR(20),
    rack_location VARCHAR(50),
    purchase_date DATE,
    warranty_years INTEGER,
    vendor VARCHAR(100),
    last_sync TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
