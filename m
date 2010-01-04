From: Daniel LeBlanc <daniel.leblanc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [NILFS] NILFS filesystem stability
Date: Mon, 4 Jan 2010 12:08:05 -0500
Message-ID: <aff377151001040908i2f2ff5ebq4c83fe7393c840d6@mail.gmail.com>
References: <71d11f861001011335j459d29e8oddb7f4d49dd41126@mail.gmail.com>
	<20100103.163927.12303106.ryusuke@osrg.net>
	<aff377151001040903m6a2cf379q99daf8a517ffeabb@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:mime-version:received:in-reply-to:references
	:date:message-id:subject:from:to:cc:content-type
	:content-transfer-encoding;
	bh=tLzncP3OVVEWnDne52BaQkqtRQ6v8sWVgv8cTf6rMhw=;
	b=esawGNmE3p76ooYKUb/hSuwol40hxVkszuimqaLwo2PW87Sr/RbXRC2f20dfbeH+Gj
	96ADtAztac25PWd5tnCCXQnmBBYVLE3tUewaMD+OcstSotPYky7WnzJZE58uflu8qPwK
	+MfMl+06EW0ZzfZOEX/h8g/1Two/1wdoKB64c=
In-Reply-To: <aff377151001040903m6a2cf379q99daf8a517ffeabb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

On Sun, Jan 3, 2010 at 2:39 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
 ...
> It still needs backup since NILFS is not of help for hardware
> malfunction. =A0However, I feel it's actually helpful for human errors
> through experiences like that.
 ...

That- I think - is the answer to a question I wanted to ask for some
times now. I've been using XFS for a while now but eventually got bad
sectors on many disks and found XFS to be of limited help when that
happens. So, looking for alternatives I got interested in NILFS
development. Do I=A0understand=A0correctly that NILFS is not really better
than other FS (xfs) when the hardware deteriorates and bad sectors
appear?
Is it in the plans to somehow 'support' bad sectors reallocation (or such)?

 ...
> Note that NILFS still lacks fsck. =A0You may go back before filesystem
> corruption, but this is not always possible since some types of
> metadata are not redundant.
 ...

Curious on any scenario you have in mind for such a case to show up?
Hardware malfunction and/or hdd access from outside NILFS? A bug?
Something else?


Cheers,
Daniel LeBlanc
software engineer
