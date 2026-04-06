import cv2
from cvzone.HandTrackingModule import HandDetector

class Tracker:
    def __init__(self):
        self.cap = cv2.VideoCapture(0)
        # Инициализируем детектор (ищем 1 руку)
        self.detector = HandDetector(detectionCon=0.8, maxHands=1)

    def get_finger_position(self):
        success, img = self.cap.read()
        if not success: return -1.0, -1.0
        
        img = cv2.flip(img, 1)
        # Находим руку и рисуем скелет (draw=True)
        hands, img = self.detector.findHands(img, draw=True)
        
        x, y = -1.0, -1.0
        if hands:
            hand = hands[0]
            # lmList - список всех 21 точек руки. Точка 8 - указательный палец
            lmList = hand["lmList"]
            # Получаем координаты и переводим их в формат 0...1
            h, w, _ = img.shape
            x = float(lmList[8][0] / w)
            y = float(lmList[8][1] / h)

        cv2.imshow("CVZone Hand Tracker", img)
        cv2.waitKey(1)
        return x, y

    def release_camera(self):
        self.cap.release()
        cv2.destroyAllWindows()