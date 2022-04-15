From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 12/27] block: add a bdev_write_cache helper
Date: Fri, 15 Apr 2022 05:41:46 +0000
Message-ID: <cf0b3178-8823-4cb2-c987-db76e005ac4d@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-13-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FqhaTrfUIQ4NPWF8rNUYFIy1CuNkuH68bv7RBix4hU=;
 b=tODTqjlAlsHeCHfKrGBmp/tDHryUzAA7ST5FHPcQ4MnODbRHDx40ZYACQv3iV8osnIwGU7mI45cL8QjiiX3HNHLJm/2G45jzrmT1Mc0fYmxAOaiV8rCseFGQ3tWvtBtqOKkXO7telm8RCXpcS8UehyxM3hRkrZHHNRI/KkJP7TEMk7gyB43Ks7EwAYOKDdyp+T6bLCR3kCDElDJEGMMNcCAvCxWOEUoPtjl4p0bl82up+6InTGQbswUlW4+y9UOfW5KkeRkP19LusgWV8XKdeXad5d5ZC2O8KmLypNfb7maetucp1RfqAl5zZNiLBqeh9L94vpoq80dB5LzJE2dZig==
In-Reply-To: <20220415045258.199825-13-hch@lst.de>
Content-Language: en-US
Content-ID: <80FC9A4858701045A17542A9B486AED5@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhIGhlbHBl
ciB0byBjaGVjayB0aGUgd3JpdGUgY2FjaGUgZmxhZyBiYXNlZCBvbiB0aGUgYmxvY2tfZGV2aWNl
DQo+IGluc3RlYWQgb2YgaGF2aW5nIHRvIHBva2UgaW50byB0aGUgYmxvY2sgbGF5ZXIgaW50ZXJu
YWwgcmVxdWVzdF9xdWV1ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2ln
IDxoY2hAbHN0LmRlPg0KPiBSZXZpZXdlZC1ieTogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4u
cGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gQWNrZWQtYnk6IERhdmlkIFN0ZXJiYSA8ZHN0ZXJiYUBz
dXNlLmNvbT4gW2J0cmZzXQ0KPiAtLS0NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENo
YWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQo=
