From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Nilfs2 crash debugging
Date: Mon, 26 Aug 2013 13:56:06 +0400
Message-ID: <1377510966.2621.3.camel@slavad-ubuntu>
References: <51F2A8A4.4020400@antoneliasson.se>
	 <51F2A945.6050909@antoneliasson.se>
	 <9016EBD5-1E01-476F-B1B9-66AE593F4728@dubeyko.com>
	 <520CB032.2000602@antoneliasson.se>
	 <FEA41B6A-7D82-4563-AAF5-D5AFA3734D79@dubeyko.com>
	 <521A1C88.9080100@antoneliasson.se>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=zp7GLsgx2aUaCLs2APObri68p2TJxqd3Wd06uRuDnvM=;
	b=MlA0W/KhsdigcR3OPlhpBR65cv8mtHpW/a8y1hLjCjVMo1pJ6WmCVD8lowizg2euSZOZXhT40b7dRaH3frRseHKPS6QoAhWpOFUokQnCUNR0FNUvkVQVdTT93AizqnP9;
In-Reply-To: <521A1C88.9080100-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 2013-08-25 at 17:02 +0200, Anton Eliasson wrote:

[snip]
> Yes. Here's another huge kernel.log for you [2]. It's 19 MB compresse=
d=20
> and 282 MB uncompressed. I blanked the log while running the stock=20
> kernel and then rebooted to the custom debugging kernel. X wouldn't=20
> start so I just logged in to a virtual terminal, changed directory to=
=20
> "~/Bilder/20130321-28 Jakobs bilder fr=C3=A5n Nederl=C3=A4nderna" and=
 then=20
> executed `cat 179.JPG >/dev/null`.
>=20
> This caused a read-only remount and a bunch of "broken bmap" messages=
 to=20
> show, followed by an "Input/Output error". I saved a copy of=20
> /var/log/kernel.log as soon as I could after that, before reinstallin=
g=20
> the stock kernel and rebooting.
>=20
> [1]: http://antoneliasson.se/publicdump/config.x86_64.last.20130825
> [2]: http://antoneliasson.se/publicdump/kernel.log.20130825.gz
>=20

Yes, it's great. Thank you. Now I can investigate the issue's
environment. I suspect that this issue is related to the issue with
"unable to handle kernel paging request" in nilfs_end_page_io(). But,
maybe, I am wrong. Anyway, it is a good basis for more detailed
understanding of the issue.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
