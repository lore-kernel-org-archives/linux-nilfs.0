From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 11/29] btrfs: use bdev_nr_sectors instead of open coding
 it
Date: Wed, 13 Oct 2021 22:36:25 +0000
Message-ID: <9e275603-359d-4492-98b5-520bbd15cc92@nvidia.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-12-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93r2xFlzBgp2P3mF+smPFUwUw7bjnKI+H5iB7xljbTo=;
 b=SRHGYjgiQSDMpeU8plPourPzimx8C9mqti76X4xDngMFD0zMHhNHrs3uNTZgRunpFUHLBPc9Yi5UT326e1NVDD33mphxWlmRwrqbJ3BAhsHcOhf1ocWHKZb942REEjq/5xmUJTOEXZZYEJxRBfxqKnw1WlG1uTFZXmBsFKHD8Xvyp7KDGvUgSEDq8AIEGb9g3qA/WJz8T9HL1MbwLBUAXtWwFuh1gnyJka07ouO4bLW8W3QCRsS4j2wY80VTMLZDcPAUIL2T5UbeUbEhgOoPPgOHN+0sjQggavHruRhIUlldSZTrYVzg+Fvr7K45eEgoIM5YU3+QItIddGQy6Bo8gw==
In-Reply-To: <20211013051042.1065752-12-hch@lst.de>
Content-Language: en-US
Content-ID: <0B96D8945A56EF41ABFC6A6B96A751D7@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTIvMjAyMSAxMDoxMCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0
aGUgcHJvcGVyIGhlbHBlciB0byByZWFkIHRoZSBibG9jayBkZXZpY2Ugc2l6ZS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KDQoNCkxvb2tzIGdv
b2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0K
DQoNCg==
