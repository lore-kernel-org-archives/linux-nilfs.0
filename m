From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 03/30] bcache: remove bdev_sectors
Date: Mon, 18 Oct 2021 05:46:32 +0000
Message-ID: <b910c530-1aee-c9f3-c9f7-42c89084c83d@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-4-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kINAa/Z04YU4i/wC1CQhe6PXPv9YxgHAS2zL29QmIbw=;
 b=aFzddktEz+n8maB3vSv+bLaZP8K6eHed05Q9HKZ8ZZQdwjYanhk2Pj7czaRfrsMbZiYEk9iJsjpjmlMAikohTz00+tigHbxqNXfanUhY7HyN5ngKJZf7gAsn9w509CtqP2NaOtQLyexw3M5onyqx/TLpmJRFhozksnNj9q5teXC/06Lv2NIAuQ22Wjj/SsHwJYtGb7SvIZoggHOP2NKVXghw2ySovd2rO9tVsLn3sP0BpjgIWNYd5ELjqMP6vMhsEjagE45iouZ7kTXvy0ubRZahgvrVzkKeSNxeeP8no2ggHNQBtifOWI6rjSnk/I3hoYNySrnSAnPD9121UbuwLw==
In-Reply-To: <20211015132643.1621913-4-hch@lst.de>
Content-Language: en-US
Content-ID: <276A457CC12A29429674DCE72537FB49@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTUvMjEgMDY6MjYsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBVc2UgdGhlIGVx
dWl2YWxlbnQgYmxvY2sgbGF5ZXIgaGVscGVyIGluc3RlYWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gUmV2aWV3ZWQtYnk6IEtlZXMgQ29v
ayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPg0KPiBBY2tlZC1ieTogQ29seSBMaSA8Y29seWxpQHN1
c2UuZGU+DQo+IC0tLQ0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1
bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KDQo=
