export interface ImuData {
  roll: number;
  pitch: number;
  yaw: number;
  heading_deg: number;
  speed: number;
}

export interface GnssData {
  latitude: number;
  longitude: number;
}

export interface MotorData {
  drive_motor_state: { steer: number[]; drive: number[] };
  arm_motor_state: { motor_values: number[] };
}

export interface Telemetry {
  imu: ImuData;
  gnss: GnssData;
  motor: MotorData;
}

export interface Poi {
  id: string;
  latitude: number;
  longitude: number;
  colour: string;
  text: string;
}
