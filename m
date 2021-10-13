From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 02/29] drbd: use bdev_nr_sectors instead of open coding it
Date: Wed, 13 Oct 2021 22:33:58 +0000
Message-ID: <473988dd-f18a-3ca0-7b3e-f5ad34f1b045@nvidia.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-3-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=864Gkq+OUjAaLhBpXJA5Ah2pBllzcjFIWDplOWzOyP4=;
 b=SR7TM+mzsVKJ5FcwuH4OJ/G6M7CVpu9nLgJGLji70wSll0bcXNQulE85bH5e4usBWwGp/h3mkJCnwPKOp/k9obor0lqbUS5BWCdwUcwxMwNUBhJkeO4D0dsCkCzyxiHbdC6K1KbCPqDS3pJtTx08yTpJFmn9XJKPYNzeAx4y5Vlm5I5+0upcLYyIImD+56o7GpNtg7HqYVlYnz/3EWic8VabFL+ZEqU5XPZquQRczajCRVup/HMIBFwC6o7JgXHWjmztJuu1zzKNFQweOLEdd3Mbrm7NRaULyvaUGIjZbtRmocQrCXvxm6EFz7/SB60BJR8Q9pCOfCC8Xy+Nix/I4w==
In-Reply-To: <20211013051042.1065752-3-hch@lst.de>
Content-Language: en-US
Content-ID: <43BBE4AA93E9954CAC870DE93CD2159C@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTIvMjAyMSAxMDoxMCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0
aGUgcHJvcGVyIGhlbHBlciB0byByZWFkIHRoZSBibG9jayBkZXZpY2Ugc2l6ZS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KDQpMb29rcyBnb29k
Lg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg==
