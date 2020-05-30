import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ---------------Colors---------------------

Color basicColor = Color(0xff1643CD);

// ---------------Sizes----------------------

const FontWeight appBarFontWeight = FontWeight.bold;
const double preferredSize = 50;

// ---------------Important------------------
const String passHash = "https://dev.apli.ai/accounts/api/passHash";
const String passHashSecret = "YjVd13QEMZe0JsWlkqDyEjE9jpNTZyvQ";
const String checkLogin = "https://dev.apli.ai/accounts/api/login";
const String checkLoginSecret = "j&R\$estgIKur657%3st4";
const String send_mail = "https://dev.apli.ai/accounts/api/send_mail";
const String send_mailSecret = "SbXAvLHyHhuBM1bHTqjZUDEcI8QP0EPM";

const String reachUs = "https://dev.apli.ai/accounts/api/reachus";
const String reachUsSecret = "78J9MV7ai75KNh5zxtAVFefFEWUgOQAb";
const String pdfUrltoBeReplaced =
    "https://storage.googleapis.com/aplidotai.appspot.com/";
const String pdfUrltoreplacedWith = "gs://aplidotai.appspot.com/";

const String basic_infoURL = "https://dev.apli.ai/candidate/api/basic_info";
const String projectsURL = "https://dev.apli.ai/candidate/api/projects";
const String expURL = "https://dev.apli.ai/candidate/api/experience";
const String awardsURL = "https://dev.apli.ai/candidate/api/awards";
const String skillsURL = "https://dev.apli.ai/candidate/api/skills";
const String educationURL = "https://dev.apli.ai/candidate/api/education";
const String extraCURL = "https://dev.apli.ai/candidate/api/extra_curricular";

const String apliEmailID = 'info@apli.ai';
const String apliPassword = 'Priyam112@';

// ---------------Strings--------------------
const String login = "Log In";
const String email = "Email ID";
const String password = "password";
const String signup = "Don’t have an account?";
const String jobs = "Jobs";
const String mockJob = "Mock Jobs";
const String courses = "Courses";
const String profile = "Profile";
const String updates = "Notifications";
const String jobsAvailable = "Jobs Available";
const String applied = "Applied";
const String allJobs = "All Jobs";
const String incomplete = "Incomplete";
const String overview = "Overview";
const String content = "Content";
const String certificate = "Certificate";
const String enroll = "Enroll";
const String completion =
    "On completion of the course, you will receive a certificate.";
const String copyright = "Apli | Copyrighted @2020";
const String rememberMeText = "Remember Me";
const String forgot = "Forgot Password?";
const String psychTest = "Test";
const String resume = "Resume";
const String editResume = "Edit Resume";
const String videoIntro = "Video Intro";
const String resumeSlogan =
    "Keep your resume upto date with latest skills for all jobs that you apply for";
const String videoIntroSlogan =
    "Give a short introduction of yourself  for your recruiters to see";
const String psychometryTestSlogan =
    "This is a psychometric test to help the recruiters understand your personality";
const String intro = 'Intro';
const String extra = 'Exta-Curriculars';
const String projects = 'Projects';
const String awards = 'Awards';
const String experience = 'Experience';
const String education = 'Education';
const String licenses = 'Licenses and Certifications';
const String skills = 'Skills';
const String editEdu = 'Edit Education';
const String clg = 'Current Education';
const String noDetails = "You haven't added any details yet";
const String otherCourses = 'Other Courses';
const String twelve = 'Class XII / Diploma';
const String ten = 'Class X';

// JOB SECTION APIS  //

const String allJobsURL = "https://dev.apli.ai/candidate/api/get_jobs";
const String appliedJobsURL =
    "https://dev.apli.ai/candidate/api/get_submitted_jobs";
const String incompleteJobsURL =
    "https://dev.apli.ai/candidate/api/get_pending_jobs";
const String companyIntroURL =
    "https://dev.apli.ai/candidate/api/get_company_info";
const String jobApplyURL =
    "https://dev.apli.ai/candidate/api/new_job_application";
const String interViewQuestionsURL =
    "https://dev.apli.ai/candidate/api/get_job_interview_questions";
const String submitVideoInterviewURL =
    "https://dev.apli.ai/candidate/api/submit_question_video_interview";
const String acceptInterviewURL =
    "https://dev.apli.ai/candidate/api/accept_interview";
const String acceptJobOfferURL =
    "https://dev.apli.ai/candidate/api/accept_offer";
const String uploadLetterURL =
    "https://dev.apli.ai/candidate/api/update_signed_letter";

// MOCKJOBS SECTION APIS  //
const String mockJobsURL =
    "https://dev.apli.ai/candidate/api/get_mock_interview_packages";
const String mockinterViewQuestionsURL =
    "https://dev.apli.ai/candidate/api/get_mock_interview_questions";
const String addMockVideoURL =
    "https://dev.apli.ai/candidate/api/add_mock_interview_video";
const String submitMockInterviewURL =
    "https://dev.apli.ai/candidate/api/submit_final_mock_interview";

final apiDateFormat = DateFormat("yyyy-MM-dd");
const defaultPic =
    'data:img/jpeg;base64,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';

const List<String> genders = ['Male', 'Female', 'Others'];
const List<String> proficiencies = [
  'Starter',
  'Basic',
  'Intermediate',
  'Expert'
];
const List<String> experienceTypes = ['Internship', 'Job'];
const List<String> domains = [
  'Software Development',
  'Management',
  'Sales',
  'Marketing'
];

const List<String> industryTypes = [
  'Accommodations',
  'Accounting',
  'Advertising',
  'Aerospace',
  'Agriculture and Agribusiness',
  'Air Transportation',
  'Apparel and Accessories',
  'Automobile',
  'Banking',
  'Beauty and Cosmetics',
  'Biotechnology',
  'Chemical',
  'Communications',
  'Computer',
  'Construction',
  'Consulting',
  'Consumer Products',
  'Education',
  'Electronics',
  'Employment',
  'Energy',
  'Entertainment and Recreation',
  'Fashion',
  'Financial Services',
  'Fine Arts',
  'Food and Beverage',
  'Health',
  'Information Technology',
  'Insurance',
  'Journalism and News',
  'Legal Services',
  'Manufacturing',
  'Media and Broadcasting',
  'Medical Devices and Supply',
  'Motion Pictures and Video',
  'Music',
  'Pharmaceutical',
  'Public Administration',
  'Public Relations',
  'Publishing',
  'Real Estate',
  'Retail',
  'Service',
  'Sports',
  'Technology',
  'Telecommunications',
  'Tourism',
  'Transportation',
  'Travel',
  'Utilities',
  'Video Game',
  'Web Services'
];
