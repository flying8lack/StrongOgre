import time
import psutil  # Import for CPU usage measurement

# Replace with your Thingspeak channel details
API_KEY = "YOUR_THINGSPEAK_API_KEY"
CHANNEL_ID = "YOUR_THINGSPEAK_CHANNEL_ID"
FIELD_1 = 1  # Field number for sensor data (adjust if needed)

# Function to read sensor data from the specified pin
def read_sensor(pin):
    # Replace this with your sensor-specific code
    # Example for GPIO pin reading (adjust pin number):
    import RPi.GPIO as GPIO
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(pin, GPIO.IN)
    sensor_value = GPIO.input(pin)  # Read digital value (0 or 1)
    GPIO.cleanup()
    return sensor_value


def send_data_to_thingspeak(sensor_data):
    import requests

    url = f"https://api.thingspeak.com/update?api_key={API_KEY}&field={FIELD_1}&value={sensor_data}"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            print("Data sent successfully to ThingSpeak.")
        else:
            print(f"Error sending data: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"Error sending data: {e}")

def main():
    # Get Raspberry Pi model name for informative logging
    pi_model = psutil.virtual_machine().system()

    while True:
        start_time = time.time()

        # Read sensor data
        sensor_value = read_sensor(pin)  # Replace 'pin' with your actual pin number

        # Measure CPU usage
        cpu_usage = psutil.cpu_percent()

        # Send data to ThingSpeak
        send_data_to_thingspeak(sensor_value)

        end_time = time.time()
        total_time = end_time - start_time

        print(f"Raspberry Pi Model: {pi_model}")
        print(f"Sensor value: {sensor_value}")
        print(f"CPU Usage: {cpu_usage:.2f}%")
        print(f"Total execution time: {total_time:.4f} seconds")
        print("-" * 30)

        # Adjust sampling interval as needed (e.g., 5 seconds)
        time.sleep(5)

if __name__ == "__main__":
    main()
