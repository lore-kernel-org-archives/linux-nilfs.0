From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 06/29] nvmet: use bdev_nr_sectors instead of open coding
 it
Date: Wed, 13 Oct 2021 22:33:16 +0000
Message-ID: <d061489a-af65-93e3-0e1a-5742b009ac79@nvidia.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-7-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9WNQaxe89gO8xkELPjDEHsY1By2K3v3YTrmazx1lBU=;
 b=GpOJhl+LAJaWxKBV1Lu0pgqBbaNRzR4vWpX9AHg7cbRd6RliVVV7f18G/yIuJ8n1yQZaotQ2qYnEeRYtq/oQZ2dbOkxDwwEk56ziBY4u5ui5jowrM33FF+N6wunLiRPk0MwRj6MxAIXnOQVMa8TR0QUhVD3laiur9XyQGsk1huuudfCXENn8bIerLX3JaXqu61E4lnwcQY/trhmzNArzxglLKCv+DwiATk1sLIRKDGLWuQhnRLvCzuVa7EUB/p/kgYZZ4oF5HjzVKXnFWA9156VxZ480AH109Os/mWmzLyqRvoJvRKlQbQOV9kGywsKhHsVynOMT2NlDWYae9/cUFQ==
In-Reply-To: <20211013051042.1065752-7-hch@lst.de>
Content-Language: en-US
Content-ID: <61F41960B16F6C40AEC03242CA4F6BBB@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTIvMjAyMSAxMDoxMCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0
aGUgcHJvcGVyIGhlbHBlciB0byByZWFkIHRoZSBibG9jayBkZXZpY2Ugc2l6ZS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KTG9v
a3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5j
b20+DQo=
