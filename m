From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 08/29] fs: use bdev_nr_sectors instead of open coding it
 in blkdev_max_block
Date: Wed, 13 Oct 2021 22:35:20 +0000
Message-ID: <9d9cfa90-9fe6-23a7-ba13-c12d6fd59a0c@nvidia.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-9-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BA4+fMaIErfDk2S+mlt05OClkBEhOJ6653ORhF4ddts=;
 b=XAr88+6xlae7ynws/e6e89Y4GJYSBBH3I/I9GYBFJJOdKcNAFqdzlqGTHhSFI1G34aBMChxpTAPtUymj08BcJARbzGWi/RuylQjAiqRwhGWX6uEpwywgPCQ/RM53YQ39K76tzeNeLn7sflMQWdDMdrzBuDNKfFLIO6nzLvNPiKiTs5EW7QXq6GCY0Fh/oLxGwWFcXXTrfYKylDRCDMTT9v4fCHmj743vXtl6Gc1BCAnFJ03g0y6CRfw9ucnsQYqLNCEd1edHpS/4zocCxtfM/bnTzY6phVl+kMHe2AOpAiVohl4NbpATiRhgpIQVYSqSThO68PCrsMZTI1zv1vrTTw==
In-Reply-To: <20211013051042.1065752-9-hch@lst.de>
Content-Language: en-US
Content-ID: <AC053E27003B5D4BB866AE7BB26E4310@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTIvMjAyMSAxMDoxMCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0
aGUgcHJvcGVyIGhlbHBlciB0byByZWFkIHRoZSBibG9jayBkZXZpY2Ugc2l6ZS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KDQpM
b29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlh
LmNvbT4NCg0KDQo=
