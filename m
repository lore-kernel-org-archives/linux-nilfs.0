From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 25/30] block: add a sb_bdev_nr_blocks helper
Date: Mon, 18 Oct 2021 05:48:14 +0000
Message-ID: <04beef49-8269-3120-517a-111357ecd2db@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-26-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoTdo9YmkAjQuMhlsR5rPkyIMnhuRGEF00hqwgXnEBQ=;
 b=hoaoUNKEqX5CPSf7/ier5U8E+/d6KMKgK90jiWg07SyhFUKeiNCwBKUbNls/A0evw43Dngj5kLoW83S+mcdHDyrYey9cWEyM+JL/oBBVZHfU3rXsgK8VOAqh0wx/GDMnlfAjsh3wfeH/JwmpKqVDEcmLWIN7+nrYrILtv4NFoAMzyA+2MiIrbfKXKlgVaByB+AMCZVRpUOG8FaYAS6if3IXZvNgnMW8bKedtz7UlgeTpaLLAMw2P145S709qbYE1lcsqPOIC30KzbmKACz/W1xI2mOKRT+PISyhxZlALvYjJwaESaGx7waO0/2IFLyQRwInupuDv0P95JpS765xD8Q==
In-Reply-To: <20211015132643.1621913-26-hch@lst.de>
Content-Language: en-US
Content-ID: <E92FCF7DB99A724CBD69B890C7E02284@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTUvMjEgMDY6MjYsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBBZGQgYSBoZWxw
ZXIgdG8gcmV0dXJuIHRoZSBzaXplIG9mIHNiLT5zX2JkZXYgaW4gc2ItPnNfYmxvY2tzaXplX2Jp
dHMNCj4gYmFzZWQgdW5pdGVzLiAgTm90ZSB0aGF0IFNFQ1RPUl9TSElGVCBoYXMgdG8gYmUgb3Bl
biBjb2RlZCBkdWUgdG8NCj4gaW5jbHVkZSBkZXBlbmRlbmN5IGlzc3VlcyBmb3Igbm93LCBidXQg
SSBoYXZlIGEgcGxhbiB0byBzb3J0IHRoYXQgb3V0DQo+IGV2ZW50dWFsbHkuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCg0KTG9va3MgZ29vZC4N
Cg0KUmV2aWV3ZWQtYnk6IENoaWF0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCg0K
