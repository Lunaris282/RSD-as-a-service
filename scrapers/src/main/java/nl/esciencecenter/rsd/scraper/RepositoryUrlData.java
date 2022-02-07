package nl.esciencecenter.rsd.scraper;

import java.time.LocalDateTime;

public record RepositoryUrlData(String id, String software, String url, String license, LocalDateTime licenseScrapedAt,
								String commitHistory, LocalDateTime commitHistoryScrapedAt) {
}
