From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 08/27] btrfs: use bdev_max_active_zones instead of open
 coding it
Date: Fri, 15 Apr 2022 05:40:23 +0000
Message-ID: <f4851d27-c4c6-7fc2-9c32-ee1ae891c598@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-9-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeqRsi5qUzfOoVz5mMgRNawNkDuhgO1aMKf+Il7fseA=;
 b=azL6I2325DJzuoKqfpuEgluZIpFyKYMAebUZ3uVLb+D8/min/TTIi0GhU5pc5YcoWY3ypu+cvJ2h6kPJ5DzWPQF4Ka+PXGN3utcWBPdOFzQM0cPm4O9O4qw7kZkIL66j6Q/KzDy1bbaz9J0Kfi4ET5fFckgv1moefbaXSwIgsZyMZVVcwedMQE9MkQdzz7yiw2Hp0GxG9oyd07bJYodqBAMeLHSLU9v1uLw2SJF20VOgGob04i3fJh2YXt3oe4bFonCDvWM27tK/2xJHnIzjDDRRz6fQ5V7oHq5tr0JbngQ43LFbjBDPrF91HcbYlB4OVQbnZN4foXvyhXQ7TW/HMQ==
In-Reply-To: <20220415045258.199825-9-hch@lst.de>
Content-Language: en-US
Content-ID: <3BD681E83CBB8E4A8EA752EE0A94BCBE@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFNpZ25lZC1vZmYt
Ynk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiBSZXZpZXdlZC1ieTogSm9oYW5u
ZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNvbT4NCj4gQWNrZWQtYnk6IERh
dmlkIFN0ZXJiYSA8ZHN0ZXJiYUBzdXNlLmNvbT4NCj4gLS0tDQoNCkxvb2tzIGdvb2QuDQoNClJl
dmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0K
