#!/usr/bin/env php
<?php

/**
 * News CLI - Display latest tech/linux news from Phoronix
 */

class NewsCLI {
    private const RSS_URL = 'https://www.phoronix.com/rss.php';
    private const DEFAULT_LIMIT = 10;

    public function run($argc, $argv) {
        $limit = $this->parseArguments($argc, $argv);

        echo "🔥 Latest Tech/Linux News from Phoronix\n";
        echo str_repeat("=", 50) . "\n\n";

        try {
            $news = $this->fetchNews();
            $this->displayNews($news, $limit);
        } catch (Exception $e) {
            echo "❌ Error: " . $e->getMessage() . "\n";
            exit(1);
        }
    }

    private function parseArguments($argc, $argv) {
        $limit = self::DEFAULT_LIMIT;

        if ($argc > 1) {
            $arg = $argv[1];
            if (is_numeric($arg) && $arg > 0 && $arg <= 50) {
                $limit = (int)$arg;
            } else {
                echo "Usage: php news.php [limit]\n";
                echo "  limit: Number of news items to show (1-50, default: 10)\n\n";
                exit(1);
            }
        }

        return $limit;
    }

    private function fetchNews() {
        $context = stream_context_create([
            'http' => [
                'timeout' => 10,
                'user_agent' => 'NewsCLI/1.0'
            ]
        ]);

        $xml = file_get_contents(self::RSS_URL, false, $context);

        if ($xml === false) {
            throw new Exception("Failed to fetch news feed");
        }

        $rss = simplexml_load_string($xml);

        if ($rss === false) {
            throw new Exception("Failed to parse RSS feed");
        }

        $news = [];
        foreach ($rss->channel->item as $item) {
            $news[] = [
                'title' => (string)$item->title,
                'link' => (string)$item->link,
                'description' => (string)$item->description,
                'pubDate' => (string)$item->pubDate,
                'timestamp' => strtotime((string)$item->pubDate)
            ];
        }

        return $news;
    }

    private function displayNews($news, $limit) {
        $count = min($limit, count($news));

        for ($i = 0; $i < $count; $i++) {
            $item = $news[$i];

            echo "📌 " . $this->cleanText($item['title']) . "\n";
            echo "   📅 " . date('M j, Y H:i', $item['timestamp']) . "\n";
            echo "   🔗 " . $item['link'] . "\n";

            // show a short description
            if (!empty($item['description'])) {
                $description = $this->cleanText(strip_tags($item['description']));
                $shortDesc = strlen($description) > 150 ?
                    substr($description, 0, 150) . "..." :
                    $description;
                echo "   💬 " . $shortDesc . "\n";
            }

            echo "\n";
        }

        echo "📊 Showing {$count} of " . count($news) . " available news items\n";
        echo "🌐 Source: Phoronix (https://www.phoronix.com)\n";
    }

    private function cleanText($text) {
        return trim(preg_replace('/\s+/', ' ', $text));
    }
}

// run the cli
$cli = new NewsCLI();
$cli->run($argc, $argv);
