From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 11/30] affs: use bdev_nr_sectors instead of open coding it
Date: Mon, 18 Oct 2021 06:22:53 +0000
Message-ID: <c3b7ccf9-21e5-144e-969b-1ce91ebab13f@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-12-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayyanfnzFDbgewTLc054vxad7IKtCHZujvd+hjw2jPs=;
 b=uPRfej+Zz//AcRvmXAd22eHzMRJ8SXtJGJiSHGo9YeHGcpcySXy4RYvnzPrln5JOKC6Q3OyWgriuc10VoN1lnVGnXzKlu4f1j/MP/pTyaXRGNNGBHu7e0aQIAzP6OJtAXj2PHh3Qu1bpa0s/5kTFdRcS/H+e4Wc67dktYf1SfdvmjdnI1ZHGg2vdOAGaDMcxXVYLvCubWdJ0DIz8w6BTwn3rBFHcTFZyIHBs1HSg9LkAzUY+XIpGfhanv/vbwt+1TALZScdAqEqF40XPOmcyaMkmMeTA4DbmYZO4/XuX1mYviE4xUcr9VSyM2P1gSmFdwIyT3hXoJDIg2hqSsb4dvQ==
In-Reply-To: <20211015132643.1621913-12-hch@lst.de>
Content-Language: en-US
Content-ID: <64D540410AA39A4599DCD51920BC3A12@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTUvMjEgMDY6MjYsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBVc2UgdGhlIHBy
b3BlciBoZWxwZXIgdG8gcmVhZCB0aGUgYmxvY2sgZGV2aWNlIHNpemUuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gUmV2aWV3ZWQtYnk6IEtl
ZXMgQ29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdl
ZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KDQo=
