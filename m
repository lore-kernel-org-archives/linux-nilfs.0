From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cleaner: run one cleaning pass based on minimum free space
Date: Mon, 5 Apr 2010 14:35:51 +0200
Message-ID: <l2wee5afd761004050535l6214e37dja6f20737865dd856@mail.gmail.com>
References: <20100329.125908.56566467.ryusuke@osrg.net>
	 <4BB02E0F.90001@prnet.org>
	 <20100329.163902.263795283.ryusuke@osrg.net>
	 <20100405.120226.98047309.ryusuke@osrg.net>
	 <4BB99633.1030701@prnet.org>
	 <y2gee5afd761004050430gd8c60707s9505a0d680345fe6@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:in-reply-to:references
         :date:received:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        bh=YKZedf2CN4K3kXXTQo6zW3VuFzR5PO92AhKJ4S3Dd8g=;
        b=IpTfznHhupAk59PpIAscghVk3Ij7cihlJcDARHJv7REOV3BQ/J1SMtSMq70cwcfGHc
         Cs0IbjyZS1ryRPMN6wzg+tJb02lY7Ta+EYrehg6r8JrWLVY932m88cJeFeCrZCKBQ5pI
         tGWQxtPt3BfyKOPWddomsQZL6DZpzX1GWMMYA=
In-Reply-To: <y2gee5afd761004050430gd8c60707s9505a0d680345fe6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hallo,
May I break into this discussion with something perhaps partially
connected to the thread:
I had my usual disk full problem again on a half full partition after
a power crash, that so far has not been explained yet.

Did any of you pick up anything in the cleanerd code that might point
somewhere in the direction of a solution?

Regards

Jan de Kruyf.

Its a beautiful quiet rainy day in Johannesburg. The earth is full of g=
lory!



On Mon, Apr 5, 2010 at 9:50 AM, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
>
> Hi,
>
> Actually I run with min_clean_segments at 250 and found that to be a
> good value. However for example for a 2 gbyte usb key, this value wou=
ld
> not work at all, therefor I find it a good idea to set the default at
> 10% as it would be more general for any device size as lots of people
> simply try the defaults without changing configuration files. I reall=
y
> like your idea with having a second set of nsegments_per_clean and
> cleaning_interval_parameters for < min_clean_segments. I am wondering=
 if
> adaptive optimization will be good, as I think different people will
> expect different behavior. =A0Someones might prefer the system using =
100%
> io usage for cleaning and the disk not getting full. Other ones might
> prefer the disk getting full and using less io usage. Therefor I thin=
k
> it would add a lot of parameters to the configuration file for giving
> people the ability to tune it correctly, and this would possibly
> complicate the configuration to much.
>
> If you decide for the second set of nsegments_per_clean and
> cleaning_interval_parameters, please tell me if I should implement it=
 or
> if you will implement it, not that we are working on the same
> functionality at the same time.
>
> I think good names might be
>
> mc_nsegments_per_clean and
> mc_cleaning_interval
>
> as this would be compatible with the current indentation in
> nilfs_cleanerd.conf.
>
> What would you take as default values ? As you always told that it wo=
uld
> be preferable to reduce cleaning_interval instead of increasing
> nsegments_per_clean would you set cleaning interval to 0 in this case
> causing permanent cleaning and leave nsegements_per_clean at or which
> values would you choose ?
>
> Thanks in advance
> Bye,
> David Arendt
>
> On 04/05/10 05:02, Ryusuke Konishi wrote:
> > Hi!
> > On Mon, 29 Mar 2010 16:39:02 +0900 (JST), Ryusuke Konishi <ryusuke@=
osrg.net> wrote:
> >
> >> On Mon, 29 Mar 2010 06:35:27 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>=
 wrote:
> >>
> >>> Hi,
> >>>
> >>> here the changes
> >>>
> >>> Thank in advance,
> >>> David Arendt
> >>>
> >> Looks fine to me. =A0Will apply later.
> >>
> >> Thanks for your quick work.
> >>
> >> Ryusuke Konishi
> >>
> > I enhanced your change so that min_clean_segments and
> > max_clean_segments can be specified with a ratio (%) or an absolute
> > value (MB, GB, and so on) of capacity.
> >
> > The change is available on the head of util's git repo.
> >
> > Now, my question is how we should set the default value of these
> > parameters. =A0During test, I got disk full several times, and I fe=
el
> > min_free_segments =3D 100 is a bit tight.
> >
> > Of course this depends on the usage of each, but I think that the
> > default values are desirable to have some generality (when possible=
).
> >
> > The following setting is my current idea for this. =A0How does it l=
ook?
> >
> > =A0min_clean_segments =A0 =A0 =A010%
> > =A0max_clean_segments =A0 =A0 =A020%
> > =A0clean_check_interval =A0 =A010
> >
> > I also feel GC speed should be accelerated than now while the
> > filesystem is close to disk full. =A0One simple method is adding
> > optional nsegments_per_clean and cleaning_interval parameters for <
> > min_clean_segments. =A0Or, some sort of adaptive acceleration shoul=
d be
> > applied.
> >
> > I'm planning to make the next util release after this settles down.
> >
> > Any idea?
> >
> > Thanks,
> > Ryusuke Konishi
> >
> >
> >>> On 03/29/10 05:59, Ryusuke Konishi wrote:
> >>>
> >>>> Hi,
> >>>> On Sun, 28 Mar 2010 23:52:52 +0200, David Arendt <admin-/LHdS3kC8Bc@public.gmane.org=
g> wrote:
> >>>>
> >>>>
> >>>>> Hi,
> >>>>>
> >>>>> thanks for applying the patches. I did all my tests on 2 gbyte =
loop
> >>>>> devices and now that it is officially in git, I deployed it to =
some
> >>>>> production systems with big disks. Here I have noticed, that I =
have
> >>>>> completely forgotten the reserved segments. Technically this is=
 not a
> >>>>> problem, but I think people changing configuration files will t=
end to
> >>>>> forget about it. I'm thinking it might be useful to add them in=
ternally
> >>>>> to min_free_segments and max_free_segments so users don't need =
to worry
> >>>>> about them. What do you think ?
> >>>>>
> >>>>>
> >>>> Ahh, we should take into account the number of reserved segments=
=2E =A0If
> >>>> not so, cleaner control with the two threshold values will not w=
ork
> >>>> properly for large drives.
> >>>>
> >>>>
> >>>>
> >>>>> If you like to change the current behavior to this behavior, I =
will
> >>>>> submit a short update patch.
> >>>>>
> >>>>>
> >>>> Yes, please do.
> >>>>
> >>>>
> >>>>
> >>>>> I am thinking about getting the number of reserved segments thi=
s way:
> >>>>>
> >>>>> (nilfs_cleanerd->c_nilfs->n_sb->s_nsegments *
> >>>>> nilfs_cleanerd->c_nilfs->n_sb->s_r_segments_percentage) / 100
> >>>>>
> >>>>> or do you know any better way ?
> >>>>>
> >>>>>
> >>>> The kernel code calulates the number by:
> >>>>
> >>>> =A0 =3D max(NILFS_MIN_NRSVSEGS,
> >>>> =A0 =A0 =A0 =A0 DIV_ROUND_UP(nsegments * r_segments_percentage, =
100))
> >>>>
> >>>> =A0 where NILFS_MIN_NRSVSEGS is defined in include/nilfs2_fs.h, =
and
> >>>> =A0 DIV_ROUND_UP is defined as follows:
> >>>>
> >>>> =A0#define DIV_ROUND_UP(n,d) =A0 =A0(((n) + =A0(d) - 1) / (d))
> >>>>
> >>>> The same or some equivelent calculation seems preferable.
> >>>>
> >>>> With regards,
> >>>> Ryusuke Konishi
> >>>>
> >>>>
> >>>>
> >>>>> On 03/28/10 17:26, Ryusuke Konishi wrote:
> >>>>>
> >>>>>
> >>>>>> Hi,
> >>>>>> On Sun, 28 Mar 2010 14:17:00 +0200, David Arendt <admin@prnet.=
org> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> here the nogc patch
> >>>>>>>
> >>>>>>> As changelog description for this one, we could put:
> >>>>>>>
> >>>>>>> add mount option to disable garbage collection
> >>>>>>>
> >>>>>>> Thanks in advance
> >>>>>>> Bye,
> >>>>>>> David Arendt
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>> Hmm, the patch looks perfect.
> >>>>>>
> >>>>>> Will queue both in the git tree of utils.
> >>>>>>
> >>>>>> Thanks,
> >>>>>> Ryusuke Konishi
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>
> >>>>>
> >>>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ni=
lfs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> >>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
