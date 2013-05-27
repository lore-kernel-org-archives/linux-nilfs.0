From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Mon, 27 May 2013 17:23:19 +0400
Message-ID: <1369660999.7256.7.camel@slavad-ubuntu>
References: <51A0A97A.4020503@antoneliasson.se>
	 <713B7146-DC0C-45AE-9ED2-30EB8F84FA57@dubeyko.com>
	 <51A35558.1080503@antoneliasson.se>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=SvOedLzO97TdYQuDLDIf6O/z0khgKF+/t/AJsRszlUs=;
	b=cE3hdTSUZZeEcTEb5w3XQrEGpVAdVf5PIZJDZGPCdAWMLLa/BZz2jQbkQ9AnSUtDyvXaRY1KR+Pz4RUmLRI4wazWCZPxfhcFZXDTa4fIymIa96wX7PkL3xUrKLySgukU;
In-Reply-To: <51A35558.1080503-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anton,

On Mon, 2013-05-27 at 14:45 +0200, Anton Eliasson wrote:

[snip]
> Additionally, I have uploaded /var/log/everything.log spanning May 19-22 
> here:
> http://antoneliasson.se/publicdump/everything.log.gz
> 
> The first system crash is on line 14748. On line 15829 onwards nilfs 
> warns that an fs is unchecked and has a bad checksum. On line 16206 is 
> the first bad btree node error. I copied the entire /var/log tree a 
> reboot or two after I figured out that I had a bad fs. Please tell me if 
> you need any other log files from there.
> 

Thank you for all additional details and, especially, for the system
log. Your system log is really interesting. It is first time when I can
see crash dump before error messages about broken bmap. It is really
important detail, I suppose. So, I need to investigate all your
information more deeply. Maybe, I will ask about additional information
later. But, currently, I have enough and I need to think over about
known issue's environment.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
