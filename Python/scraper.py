import requests
import sys
import bs4
from threading import Thread
from queue import Queue, Empty

base_url = 'https://www.ncei.noaa.gov/data/global-hourly/access/'

class ScraperThread(Thread):

    def __init__(self, queue: Queue):
        super(ScraperThread, self).__init__()
        self.tasks = queue

    def run(self):
        while True:
            try:
                year = self.tasks.get(timeout=3)
                r = requests.get(base_url + str(year))
                soup = bs4.BeautifulSoup(r.content)
                urls = soup.find_all('a', href=True)
                csvUrls = [x.text for x in filter(lambda url: 'csv' in url.text, urls)]
                [print(base_url + str(year) + '/' + csvFile) for csvFile in csvUrls]
                sys.stdout.flush()
            except Empty:
                break


if __name__ == "__main__":

    task_queue = Queue()
    [task_queue.put(year) for year in range(1901, 2020)]
    threads = [ScraperThread(task_queue) for i in range(8)]
    [t.start() for t in threads]
    [t.join() for t in threads]


